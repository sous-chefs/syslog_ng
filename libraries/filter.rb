#
# Cookbook:: syslog_ng
# Library:: filter
#
# Copyright:: Ben Hughes <bmhughes@bmhughes.co.uk>
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

require_relative '_config'

module SyslogNg
  module Cookbook
    module FilterHelpers
      include SyslogNg::Cookbook::ConfigHelpers

      SYSLOG_NG_FILTER_FUNCTIONS ||= %w(facility filter host inlist level priority match message netmask netmask6 program source tags operator).freeze

      def filter_builder(parameters)
        raise ArgumentError, "Expected syslog-ng filter definition to be passed as a Hash, Array or String. Got a #{parameters.class}." unless parameter_valid?(parameters)

        config_string = ''

        case parameters
        when Hash
          parameters.each do |filter, parameter|
            raise ArgumentError, "Invalid operator '#{filter}' specified in filter configuration. Object type #{parameter.class}." unless filter_operator_valid?(filter)

            case parameter
            when Hash
              if filter.match?('container')
                config_string.concat(contained_group(parameter))
              else
                config_string.concat("#{filter.tr('_', ' ')} #{filter_builder(parameter)} ")
              end
            when Array
              parameter.each { |param| config_string.concat("#{filter}(#{param}) ") }
            when String
              config_string.concat("#{filter}(#{parameter}) ")
            end
          end
        when Array
          parameters.each do |parameter|
            config_string.concat("#{parameter} ")
          end
        when String
          config_string.concat(parameters)
        end

        config_string.rstrip
      end

      private

      def parameter_valid?(parameter)
        parameter.is_a?(Hash) || parameter.is_a?(Array) || parameter.is_a?(String)
      end

      def filter_operator_valid?(operator)
        SYSLOG_NG_FILTER_FUNCTIONS.include?(operator) || SYSLOG_NG_BOOLEAN_OPERATORS.include?(operator) || operator.match?('container')
      end
    end
  end
end
