#
# Cookbook:: syslog_ng
# Library:: config
#
# Copyright:: 2018, Ben Hughes <bmhughes@bmhughes.co.uk>, All Rights Reserved.
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

require 'ipaddr'

module SyslogNg
  module ConfigHelpers
    # I've added the __container__ 'operator' and __operator__ 'filter' here to allow nested boolean operation, syslog-ng doesn't know anything about it.
    SYSLOG_NG_BOOLEAN_OPERATORS ||= %w(and or and_not or_not container).freeze
    SYSLOG_NG_FILTER_FUNCTIONS ||= %w(facility filter host inlist level priority match message netmask netmask6 program source tags operator).freeze

    def config_srcdst_driver_map(driver, parameters)
      raise ArgumentError, "config_srcdst_driver_map: Expected syslog-ng destination driver name to be a String, got a #{driver.class}." unless driver.is_a?(String)
      raise ArgumentError, "config_srcdst_driver_map: Expected syslog-ng destination driver configuration attribute block to be a Hash, got a #{parameters.class}." unless parameters.is_a?(Hash)

      config_string = ''
      config_string.concat(driver + '(')
      config_string.concat(config_format_string_value(parameters['path']) + ' ') if parameters.key?('path') # Certain drivers have an unnamed 'path' parameter (eg File)
      config_string.concat(config_build_parameter_string(parameters['parameters'])) if parameters.key?('parameters')
      config_string.rstrip!
      config_string.concat(');')

      config_string
    end

    def config_filter_map(parameters)
      raise ArgumentError, "config_filter_map: Expected syslog-ng filter definition to be passed as a Hash, Array or String. Got a #{parameters.class}." unless parameters.is_a?(Hash) || parameters.is_a?(Array) || parameters.is_a?(String)

      config_string = ''
      if parameters.is_a?(Hash)
        parameters.each do |filter, parameter|
          if (SYSLOG_NG_BOOLEAN_OPERATORS.include?(filter) || filter.match?('container')) && parameter.is_a?(Hash)
            if filter.match?('container')
              config_string.concat(config_contained_group(parameter))
            else
              config_string.concat(filter.tr('_', ' ') + ' ' + config_filter_map(parameter) + ' ')
            end
          elsif SYSLOG_NG_FILTER_FUNCTIONS.include?(filter) && (parameter.is_a?(String) || parameter.is_a?(Array))
            if parameter.is_a?(String)
              config_string.concat(filter + '(' + parameter + ') ')
            elsif parameter.is_a?(Array)
              parameter.each do |param|
                config_string.concat(filter + '(' + param + ') ')
              end
              config_string.rstrip!
            end
          else
            raise ArgumentError, "config_filter_map: Invalid operator '#{filter}' specified in filter configuration. Object type #{parameter.class}."
          end
        end
        config_string.rstrip!
      elsif parameters.is_a?(Array)
        parameters.each do |parameter|
          config_string.concat(parameter + ' ')
        end
      elsif parameters.is_a?(String)
        config_string.concat(parameters)
      end
      config_string.rstrip!

      config_string
    end

    private

    def config_format_string_value(string)
      raise ArgumentError, "config_format_string_value: Expected a configuration String to format, got a #{string.class}." unless string.is_a?(String)

      param_string = string.dup
      unless %w(yes YES no NO).include?(param_string) || ip_address?(param_string)
        param_string.prepend('"')
        param_string.concat('"')
      end
      Chef::Log.debug("config_format_string_value: Formatted parameter string to: #{param_string}.")

      param_string
    end

    def config_format_parameter_pair(parameter, value)
      raise ArgumentError, "config_format_parameter_pair: Type error, got #{parameter.class} and #{value.class}. Expected String and String/Integer." unless parameter.is_a?(String) && (value.is_a?(String) || value.is_a?(Integer))

      parameter_value = value.is_a?(String) && !value.match?('"') ? config_format_string_value(value) : value.to_s # TODO: Don't like this matching for already quoted strings
      parameter_string = ''
      parameter_string.concat(parameter + '(' + parameter_value + ') ')
      Chef::Log.debug("config_format_parameter_pair: Generated parameter: #{parameter_string}.")

      parameter_string
    end

    def config_format_parameter_pair_array(array)
      #
      # Formats an array of either strings of already correctly formatted parameters or constructs a set of correctly formatted parameters from
      # an array of multiple common parameters.
      #

      raise ArgumentError, "config_format_parameter_pair_array: Excepted configuration parameters to be passed as an Array, got #{array.class}." unless array.is_a?(Array)

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
            config_format_string_value(parameter)
          end
        else
          parameter.to_s
        end
      end
      join_comma ? parameter_string.concat(parameters_formatted.join(', ')) : parameter_string.concat(parameters_formatted.join(' '))
      Chef::Log.debug("config_format_parameter_pair: Generated parameter: #{parameter_string}.")

      parameter_string
    end

    def config_build_parameter_string(parameters)
      raise ArgumentError, "config_build_parameter_string: Expected configuration parameters to be passed as a Hash, Array or String. Got a #{parameters.class}." unless parameters.is_a?(Hash) || parameters.is_a?(Array) || parameters.is_a?(String)

      param_string = ''
      return param_string if parameters.empty?
      if parameters.is_a?(Hash)
        parameters.each do |parameter, value|
          if value.is_a?(Hash) || value.is_a?(Array)
            param_string.concat(config_format_parameter_pair(parameter, config_build_parameter_string(value)))
          else
            param_string.concat(config_format_parameter_pair(parameter, value))
          end
        end
      elsif parameters.is_a?(Array)
        if parameters.count > 1
          param_string.concat(config_format_parameter_pair_array(parameters))
        else
          return parameters.first
        end
      elsif parameters.is_a?(String)
        param_string.concat(parameters + ' ')
      end
      param_string.rstrip!
      Chef::Log.debug("config_build_parameter_string: Generated parameter string is: #{param_string}.")

      param_string
    end

    def config_contained_group(hash)
      raise ArgumentError, "config_contained_group: Expected configuration parameters to be passed as a Hash, got a #{hash.class}." unless hash.is_a?(Hash)

      local_hash = hash.dup

      config_string = ''
      config_string = '(' unless local_hash.empty?

      if local_hash.key?('operator')
        boolean_operator = local_hash.delete('operator')
        raise ArgumentError, "config_contained_group: Invalid combining operator '#{boolean_operator}' specified." unless SYSLOG_NG_BOOLEAN_OPERATORS.include?(boolean_operator)
        Chef::Log.debug("config_contained_group: Contained group operator is '#{boolean_operator}'.")
      else
        boolean_operator = 'and'
      end

      local_hash.each do |filter, value|
        if value.is_a?(String)
          config_string.concat(config_contained_group_append(config_string, boolean_operator, filter, value))
        elsif value.is_a?(Array)
          value.each do |val|
            config_string.concat(config_contained_group_append(config_string, boolean_operator, filter, val))
          end
        elsif value.is_a?(Hash)
          if config_string.include?(')')
            config_string.concat(boolean_operator.tr('_', ' ') + ' ' + config_contained_group(value))
          else
            config_string.concat(config_contained_group(value) + ' ')
          end
        else
          raise "Invalid value found. Got a #{value.class}."
        end
      end
      config_string.rstrip!
      config_string.concat(')') unless local_hash.empty?

      config_string
    end

    def config_contained_group_append(config_string, operator, filter, value)
      append_string = if config_string.include?(')')
                        operator.tr('_', ' ') + ' ' + filter + '(' + value + ') '
                      else
                        filter + '(' + value + ') '
                      end
      append_string
    end

    def ip_address?(string)
      IPAddr.new(string).ipv4? || IPAddr.new(string).ipv6?
    rescue IPAddr::InvalidAddressError
      false
    end
  end
end
