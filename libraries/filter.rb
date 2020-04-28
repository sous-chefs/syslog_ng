#
# Cookbook:: syslog_ng
# Library:: filter
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

require_relative '_common'

module SyslogNg
  module Cookbook
    module FilterHelpers
      include SyslogNg::Cookbook::CommonHelpers
      def filter_builder(parameters)
        raise ArgumentError, "filter_builder: Expected syslog-ng filter definition to be passed as a Hash, Array or String. Got a #{parameters.class}." unless parameters.is_a?(Hash) || parameters.is_a?(Array) || parameters.is_a?(String)

        config_string = ''
        if parameters.is_a?(Hash)
          parameters.each do |filter, parameter|
            if (SYSLOG_NG_BOOLEAN_OPERATORS.include?(filter) || filter.match?('container')) && parameter.is_a?(Hash)
              if filter.match?('container')
                config_string.concat(contained_group(parameter))
              else
                config_string.concat(filter.tr('_', ' ') + ' ' + filter_builder(parameter) + ' ')
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
              raise ArgumentError, "filter_builder: Invalid operator '#{filter}' specified in filter configuration. Object type #{parameter.class}."
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
    end
  end
end
