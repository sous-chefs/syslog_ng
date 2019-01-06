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

module SyslogNg
  module ConfigHelpers
    # I've added a __container__ 'operator' and __operator__ 'filter' here to allow nested boolean operation, syslog-ng doesn't know anything about it.
    SYSLOG_NG_BOOLEAN_OPERATORS = %w(and or and_not or_not container).freeze
    SYSLOG_NG_FILTER_FUNCTIONS = %w(facility filter host inlist level priority match message netmask netmask6 program source tags operator).freeze

    def config_source_driver_map(driver, parameters)
      raise ArgumentError, "config_source_driver_map: Expected syslog-ng source driver name to be a String, got a #{driver.class}." unless driver.is_a?(String)
      raise ArgumentError, "config_source_driver_map: Expected syslog-ng source driver configuration attribute block to be a Hash, got a #{parameters.class}." unless parameters.is_a?(Hash)

      config_string = ''
      config_string.concat(driver + '(')
      config_string.concat(config_build_parameter_string(parameters)) unless parameters.nil? || parameters.empty?
      config_string.concat(');')

      config_string
    end

    def config_destination_driver_map(driver, parameters)
      raise ArgumentError, "config_destination_driver_map: Expected syslog-ng destination driver name to be a String, got a #{driver.class}." unless driver.is_a?(String)
      raise ArgumentError, "config_destination_driver_map: Expected syslog-ng destination driver configuration attribute block to be a Hash, got a #{parameters.class}." unless parameters.is_a?(Hash)

      config_string = ''
      config_string.concat(driver + '(')
      config_string.concat(config_format_string(parameters['path']) + ' ') if parameters.key?('path') # Certain drivers have an unnamed 'path' parameter (eg File)
      config_string.concat(config_build_parameter_string(parameters['parameters'])) if parameters.key?('parameters')
      config_string.rstrip!
      config_string.concat(');')

      config_string
    end

    def config_filter_map(parameters)
      raise ArgumentError, "config_filter_map: Expected syslog-ng filter definition to be passed as a Hash, got a #{parameters.class}." unless parameters.is_a?(Hash) || parameters.is_a?(Array)

      config_string = ''
      if parameters.is_a?(Hash)
        parameters.each do |filter, parameter|
          if SYSLOG_NG_BOOLEAN_OPERATORS.include?(filter) && parameter.is_a?(Hash)
            if filter.eql?('container')
              config_string.concat(config_contained_group_string(parameter))
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
            raise ArgumentError, "config_filter_map: Invalid operator '#{filter}' specified in filter configuration. #{parameter.class}"
          end
        end
        config_string.rstrip!
      elsif parameters.is_a?(Array)
        parameters.each do |parameter|
          config_string.concat(parameter)
        end
      elsif parameters.is_a?(String)
        config_string.concat(parameters)
      end

      config_string
    end

    private

    def config_format_string(string)
      raise ArgumentError, "config_format_string: Expected a configuration String to format, got a #{string.class}." unless string.is_a?(String)

      param_string = string.dup
      param_string.prepend('"')
      param_string.concat('"')
      Chef::Log.debug("config_format_string: Formatted parameter string to: #{param_string}.")

      param_string
    end

    def config_format_parameter(parameter, value)
      raise ArgumentError, "config_format_parameter: Type error, got #{parameter.class} and #{value.class}." unless parameter.is_a?(String) && (value.is_a?(String) || value.is_a?(Integer))

      parameter_value = value.is_a?(String) ? config_format_string(value) : value.to_s
      parameter_string = ''
      parameter_string.concat(parameter + '(' + parameter_value + ') ')
      Chef::Log.debug("config_format_parameter: Generated parameter: #{parameter_string}.")

      parameter_string
    end

    def config_build_parameter_string(parameters)
      raise ArgumentError, "config_build_parameter_string: Expected configuration parameters to be passed as a Hash or Array, got a #{parameters.class}." unless parameters.is_a?(Hash) || parameters.is_a?(Array)
      param_string = ''
      return param_string if parameters.empty?
      if parameters.is_a?(Hash)
        parameters.each do |parameter, value|
          if !(value.is_a?(Hash) && value.is_a?(Array))
            param_string.concat(config_format_parameter(parameter, value))
          else
            param_string.concat(config_build_parameter_string(value))
          end
        end
      elsif parameters.is_a?(Array)
        parameters.each do |parameter|
          param_string.concat(parameter + ' ')
        end
      end
      param_string.rstrip!
      Chef::Log.debug("config_build_parameter_string: Generated parameter string is: #{param_string}.")

      param_string
    end

    def config_contained_group_string(hash)
      raise ArgumentError, "config_contained_group_string: Expected configuration parameters to be passed as a Hash, got a #{hash.class}." unless hash.is_a?(Hash)

      config_string = '('
      if hash.key?('operator')
        boolean_operator = hash.delete('operator')
        raise ArgumentError, "config_contained_group_string: Invalid combining operator '#{boolean_operator}' specified." unless SYSLOG_NG_BOOLEAN_OPERATORS.include?(boolean_operator)
        Chef::Log.debug("config_contained_group_string: Contained group operator is '#{boolean_operator}'.")

        hash.each do |filter, value|
          if value.is_a?(String)
            if config_string.include?(')')
              config_string.concat(boolean_operator.tr('_', ' ') + ' ' + filter + '(' + value + ') ')
            else
              config_string.concat(filter + '(' + value + ') ')
            end
          elsif value.is_a?(Array)
            value.each do |val|
              if config_string.include?(')')
                config_string.concat(boolean_operator.tr('_', ' ') + ' ' + filter + '(' + val + ') ')
              else
                config_string.concat(filter + '(' + val + ') ')
              end
            end
          else
            raise
          end
        end
        config_string.rstrip!
        config_string.concat(')')

        config_string
      end
    end
  end
end
