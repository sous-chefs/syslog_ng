#
# Cookbook:: syslog_ng
# Library:: source_dest
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

require_relative '_config'

module SyslogNg
  module Cookbook
    module SourceDestinationHelpers
      include SyslogNg::Cookbook::ConfigHelpers
      def source_builder(driver:, parameters:, multiline: false)
        raise ArgumentError, "source_builder: Expected syslog-ng driver name to be a String, got a #{driver.class}." unless driver.is_a?(String)
        raise ArgumentError, "source_builder: Expected syslog-ng driver configuration attribute block to be a Hash, got a #{parameters.class}." unless parameters.is_a?(Hash)

        config = []

        config.push(driver.dup.concat('('))
        config.push(format_string_value(parameters['path'])) if parameters.key?('path') # Certain drivers have an unnamed 'path' parameter (eg File)
        if parameters.key?('parameters')
          if multiline
            build_parameter_string(parameters: parameters['parameters']).split.each { |string| config.push(string.prepend('  ')) }
          else
            config.push(build_parameter_string(parameters: parameters['parameters']))
          end
        end
        config.push(');')

        if multiline
          config
        else
          array_join(config)
        end
      end

      alias_method :destination_builder, :source_builder
    end
  end
end
