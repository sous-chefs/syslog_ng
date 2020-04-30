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
    SYSLOG_NG_BOOLEAN_OPERATORS ||= %w(and or and_not or_not container).freeze # The __container__ 'operator' and __operator__ 'filter' are added here to allow nested boolean operation, syslog-ng doesn't know anything about it.
    SYSLOG_NG_FILTER_FUNCTIONS ||= %w(facility filter host inlist level priority match message netmask netmask6 program source tags operator).freeze
    SYSLOG_NG_REWRITE_OPERATORS ||= %w(subst set unset groupset groupunset set-tag clear-tag credit-card-mask credit-card-hash).freeze
    SYSLOG_NG_REWRITE_PARAMETERS_UNNAMED ||= %w(match replacement field tags additional_options).freeze

    module ConfigHelpers
      def format_string_value(string)
        raise ArgumentError, "format_string_value: Expected a configuration String to format, got a #{string.class}." unless string.is_a?(String)

        param_string = string.dup
        unless %w(yes YES no NO).include?(param_string) || ip_address?(param_string)
          param_string.prepend('"')
          param_string.concat('"')
        end
        Chef::Log.debug("format_string_value: Formatted parameter string to: #{param_string}.")

        param_string
      end

      def build_parameter_string(parameters:, unnamed_parameters: [])
        raise ArgumentError, "build_parameter_string: Expected configuration parameters to be passed as a Hash, Array or String. Got a #{parameters.class}." unless parameters.is_a?(Hash) || parameters.is_a?(Array) || parameters.is_a?(String)

        param_string = ''
        return param_string if parameters.empty?
        if parameters.is_a?(Hash)
          parameters.each do |parameter, value|
            if value.nil?
              next
            elsif value.is_a?(Hash) || value.is_a?(Array)
              next if value.empty?
              param_string.concat(format_parameter_pair(parameter: parameter, value: build_parameter_string(parameters: value), named: !unnamed_parameters.include?(parameter)))
            else
              param_string.concat(format_parameter_pair(parameter: parameter, value: value, named: !unnamed_parameters.include?(parameter)))
            end
          end
        elsif parameters.is_a?(Array)
          if parameters.count > 1
            param_string.concat(parameter_pair_array(parameters))
          else
            return parameters.first
          end
        elsif parameters.is_a?(String)
          param_string.concat(parameters + ' ')
        end
        param_string.rstrip!
        Chef::Log.debug("build_parameter_string: Generated parameter string is: #{param_string}.")

        param_string
      end

      def array_join(array)
        raise unless array.is_a?(Array)

        config_string = ''
        array.each do |element|
          config_string.concat(element + ' ')
        end

        config_string.gsub(/(\( )|( \))/, '( ' => '(', ' )' => ')').strip
      end

      def parameter_builder(driver: nil, path: nil, parameters: nil, configuration: nil)
        return configuration unless nil_or_empty?(configuration)

        configs = []
        if !nil_or_empty?(driver) && driver.is_a?(Array)
          driver.zip(path, parameters).each do |drv, pth, param|
            config = {}
            config[drv] = {}
            config[drv]['path'] = pth unless nil_or_empty?(pth)
            config[drv]['parameters'] = param.compact unless nil_or_empty?(param)

            configs.push(config.compact)
          end
        else
          raise ArgumentError, "parameter_builder: Invalid argument set given. driver: #{driver.class} | path: #{path.class} | parameters: #{parameters.class} | configuration: #{configuration.class}"
        end

        configs
      end

      def nil_or_empty?(property)
        return true if property.nil? || (property.respond_to?(:empty?) && property.empty?)

        false
      end

      private

      def format_parameter_pair(parameter:, value:, named: true)
        raise ArgumentError, "format_parameter_pair: Type error, got #{parameter.class} and #{value.class}. Expected String and String/Integer/Symbol." unless parameter.is_a?(String) && (value.is_a?(String) || value.is_a?(Integer) || value.is_a?(Symbol))

        parameter_value = value.is_a?(String) && !value.match?('"') ? format_string_value(value) : value.to_s # TODO: Don't like this matching for already quoted strings
        parameter_string = ''
        parameter_string.concat(parameter) if named

        if named
          parameter_string.concat('(' + parameter_value + ') ')
        else
          parameter_string.concat(parameter_value + ', ')
        end

        Chef::Log.debug("format_parameter_pair: Generated parameter: #{parameter_string}.")

        parameter_string
      end

      def parameter_pair_array(array)
        #
        # Formats an array of either strings of already correctly formatted parameters or constructs a set of correctly formatted parameters from
        # an array of multiple common parameters.
        #

        raise ArgumentError, "parameter_pair_array: Excepted configuration parameters to be passed as an Array, got #{array.class}." unless array.is_a?(Array)

        parameter_string = ''
        join_comma = false
        parameters_formatted = array.map do |parameter|
          if parameter.is_a?(String)
            if parameter.match?('\(|\)')
              # Pre-formatted
              parameter
            else
              # Needed to be formatted
              join_comma = true
              format_string_value(parameter)
            end
          else
            parameter.to_s
          end
        end
        join_comma ? parameter_string.concat(parameters_formatted.join(', ')) : parameter_string.concat(parameters_formatted.join(' '))
        Chef::Log.debug("format_parameter_pair: Generated parameter: #{parameter_string}.")

        parameter_string
      end

      def contained_group(hash)
        raise ArgumentError, "contained_group: Expected configuration parameters to be passed as a Hash, got a #{hash.class}." unless hash.is_a?(Hash)

        local_hash = hash.dup

        config_string = ''
        config_string = '(' unless local_hash.empty?

        if local_hash.key?('operator')
          boolean_operator = local_hash.delete('operator')
          raise ArgumentError, "contained_group: Invalid combining operator '#{boolean_operator}' specified." unless SYSLOG_NG_BOOLEAN_OPERATORS.include?(boolean_operator)
          Chef::Log.debug("contained_group: Contained group operator is '#{boolean_operator}'.")
        else
          boolean_operator = 'and'
        end

        local_hash.each do |filter, value|
          case value
          when String
            config_string.concat(contained_group_append(config_string, boolean_operator, filter, value))
          when Array
            value.each do |val|
              config_string.concat(contained_group_append(config_string, boolean_operator, filter, val))
            end
          when Hash
            if config_string.include?(')')
              config_string.concat(boolean_operator.tr('_', ' ') + ' ' + contained_group(value))
            else
              config_string.concat(contained_group(value) + ' ')
            end
          else
            raise "Invalid value class found, support String, Array and Hash. Got a #{value.class}."
          end
        end
        config_string.rstrip!
        config_string.concat(')') unless local_hash.empty?

        config_string
      end

      def contained_group_append(config_string, operator, filter, value)
        append_string = if config_string.include?(')')
                          operator.tr('_', ' ') + ' ' + filter + '(' + value + ') '
                        else
                          filter + '(' + value + ') '
                        end
        append_string
      end

      def ip_address?(string)
        require 'ipaddr'
        IPAddr.new(string).ipv4? || IPAddr.new(string).ipv6?
      rescue IPAddr::InvalidAddressError
        false
      end
    end
  end
end
