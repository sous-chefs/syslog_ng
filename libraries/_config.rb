#
# Cookbook:: syslog_ng
# Library:: common
#
# Copyright:: 2020, Ben Hughes <bmhughes@bmhughes.co.uk>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module SyslogNg
  module Cookbook
    SYSLOG_NG_PARAMETER_BUILD_TYPES ||= %i(source_dest rewrite).freeze
    SYSLOG_NG_PARAMETERS_UNNAMED ||= { rewrite: %w(match replacement field tags additional_options) }.freeze
    SYSLOG_NG_BOOLEAN_OPERATORS ||= %w(and or and_not or_not container).freeze # The __container__ 'operator' and __operator__ 'filter' are added here to allow nested boolean operation, syslog-ng doesn't know anything about it.
    SYSLOG_NG_FORMATTED_PARAMETER_REGEX ||= /(('|").*('|"))|(.+\(.+\))|(^(\d+ ?)+$)/.freeze

    module ConfigHelpers
      def format_parameter_value(value)
        log_chef(:debug, "Receieved value to format: #{value} as #{value.class}.")
        if value.is_a?(String)
          if %w(yes YES no NO).include?(value) || value.match?(SYSLOG_NG_FORMATTED_PARAMETER_REGEX) || ip_address?(value)
            log_chef(:debug, "Returning unformatted value string '#{value}'.")
            return value
          else
            formatted = "\"#{value}\""
            log_chef(:debug, "Formatted parameter value to: #{formatted}}.")
            formatted
          end
        else
          log_chef(:debug, "Returning unformatted parameter value '#{value}' as #{value.class}.")
          value
        end
      end

      def build_parameter_string(type, parameters)
        raise ArgumentError, "Unknown parameter type #{type} to build." unless SYSLOG_NG_PARAMETER_BUILD_TYPES.include?(type)

        return '' if parameters.empty?

        parameter_string = ''

        log_chef(:debug, "Processing #{type} parameter #{parameters.class}: #{parameters}")

        case parameters
        when Hash
          parameters.each do |parameter, value|
            next if nil_or_empty?(value)

            log_chef(:debug, "Processing parameter: '#{parameter}' with value '#{value}'.")
            if value.is_a?(Hash) || value.is_a?(Array)
              parameter_string.concat("#{format_parameter_pairing(parameter: parameter, value: build_parameter_string(type, value), named: parameter_named?(parameter, type))} ")
            else
              parameter_string.concat("#{format_parameter_pairing(parameter: parameter, value: value, named: parameter_named?(parameter, type))} ")
            end
          end
        when Array
          parameter_string.concat("#{parameter_value_array(parameters)} ")
        when String
          parameter_string.concat("#{parameters} ")
        else
          raise ArgumentError, "Expected configuration parameters to be passed as a Hash, Array or String. Got a #{parameters.class}."
        end
        parameter_string.rstrip!
        log_chef(:debug, "Generated parameter string is: #{parameter_string}.")

        parameter_string
      end

      def array_join(array)
        raise unless array.is_a?(Array)

        return '' if array.empty?

        array.join(' ').gsub(/(\( )|( \))/, '( ' => '(', ' )' => ')').strip
      end

      def nil_or_empty?(property)
        return true if property.nil? || (property.respond_to?(:empty?) && property.empty?)

        false
      end

      def log_chef(level, message)
        Chef::Log.send(level, message_append_caller(message))
      end

      private

      def format_parameter_pairing(parameter:, value:, named: true)
        raise ArgumentError, "Type error, got #{parameter.class} and #{value.class}. Expected String and String/Integer/Symbol." unless parameter.is_a?(String) && (value.is_a?(String) || value.is_a?(Integer) || value.is_a?(Symbol))

        parameter_string = ''
        parameter_string.concat(parameter) if named

        if named
          log_chef(:debug, "Named #{value.class} parameter '#{parameter}' with value '#{value}'.")
          parameter_string.concat("(#{format_parameter_value(value)})")
        else
          log_chef(:debug, "Unnamed #{value.class} parameter with value '#{value}'.")
          parameter_string.concat("#{format_parameter_value(value)},")
        end

        log_chef(:debug, "Generated parameter: #{parameter_string}.")

        parameter_string
      end

      def parameter_value_array(parameter_array)
        raise ArgumentError, "Excepted configuration parameters to be passed as an Array, got #{parameter_array.class}." unless parameter_array.is_a?(Array)

        if parameter_array.empty?
          log_chef(:info, 'Empty parameter value array passed.')
          return ''
        end

        log_chef(:debug, "Processing parameter #{parameter_array.class}: #{parameter_array}.")
        parameter_string = ''
        parameters_formatted = parameter_array.map { |parameter| format_parameter_value(parameter) }
        log_chef(:debug, "Formatted parameter #{parameters_formatted.class}: #{parameters_formatted}.")

        if parameters_formatted.eql?(parameter_array)
          log_chef(:debug, 'Joining with single whitespace.')
          parameter_string.concat(parameters_formatted.join(' '))
        else
          log_chef(:debug, 'Joining with comma.')
          parameter_string.concat(parameters_formatted.join(', '))
        end

        parameter_string.strip!
        log_chef(:debug, "Generated parameter value: #{parameter_string}.")

        parameter_string
      end

      def contained_group(hash)
        raise ArgumentError, "Expected configuration parameters to be passed as a Hash, got a #{hash.class}." unless hash.is_a?(Hash)

        return '' if hash.empty?

        group_hash = hash.dup
        config_string = '('

        # Get operator from configuration hash if one is specified
        if group_hash.key?('operator')
          boolean_operator = group_hash.delete('operator')
          raise ArgumentError, "Invalid combining operator '#{boolean_operator}' specified." unless SYSLOG_NG_BOOLEAN_OPERATORS.include?(boolean_operator)
          log_chef(:debug, "Contained group operator is '#{boolean_operator}'.")
        else
          boolean_operator = 'and'
        end

        group_hash.each do |filter, value|
          log_chef(:debug, "Processing filter: '#{filter}' and value: '#{value}'.")
          case value
          when String
            config_string.concat("#{contained_group_append(config_string.include?(')'), boolean_operator, filter, value)} ")
          when Array
            value.each { |val| config_string.concat("#{contained_group_append(config_string.include?(')'), boolean_operator, filter, val)} ") }
          when Hash
            if config_string.include?(')') # Nested group
              config_string.concat("#{boolean_operator.tr('_', ' ')} #{contained_group(value)}")
            else
              config_string.concat("#{contained_group(value)} ")
            end
          else
            raise "Invalid value class found, support String, Array and Hash. Got a #{value.class}."
          end
          log_chef(:debug, "Hash pass constructed config string: '#{config_string}'.")
        end

        config_string.rstrip!
        log_chef(:debug, "Complete config string: '#{config_string}'.")
        config_string.concat(')')

        config_string
      end

      def contained_group_append(nested, operator, filter, value)
        log_chef(:debug, "Got operator: #{operator} | filter: #{filter} | value: #{value}")

        filter_value = "#{filter}(#{value})"
        filter_value.prepend("#{operator.tr('_', ' ')} ") if nested

        log_chef(:debug, "Constructed contained group string: '#{filter_value}'.")
        filter_value
      end

      def parameter_named?(parameter, type)
        result = !SYSLOG_NG_PARAMETERS_UNNAMED.fetch(type, []).include?(parameter)
        log_chef(:debug, "Type: :#{type}, Parameter: #{parameter}, Result: #{result}.")

        result
      end

      def ip_address?(string)
        require 'ipaddr'
        IPAddr.new(string).ipv4? || IPAddr.new(string).ipv6?
      rescue IPAddr::InvalidAddressError
        false
      end

      def message_append_caller(message)
        "#{caller[1][/`.*'/][1..-2]}: #{message}"
      end
    end
  end
end
