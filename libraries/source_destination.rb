#
# Cookbook:: syslog_ng
# Library:: source_dest
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
    module SourceDestinationHelpers
      include SyslogNg::Cookbook::ConfigHelpers

      def source_dest_config_builder(driver: nil, path: nil, parameters: nil, configuration: nil)
        return configuration unless nil_or_empty?(configuration) # Given raw configuration

        log_chef(:debug, "Building source/destination config. Driver: #{driver} | Path: #{path} | Parameters: #{parameters} | Configuration: #{configuration}")

        # Build configuration from properties
        configs = []
        if !nil_or_empty?(driver) && driver.is_a?(Array)
          driver.zip(path, parameters).each do |drv, pth, param|
            log_chef(:debug, "Zipped configuration set. Driver: #{drv} | Path: #{pth} | Parameters: #{param}.")

            config = {}
            config[drv] = {}
            config[drv]['path'] = pth unless nil_or_empty?(pth)
            config[drv]['parameters'] = param.compact unless nil_or_empty?(param)

            log_chef(:debug, "Built configuration: '#{config.compact}'.")
            configs.push(config.compact)
          end
        else
          raise ArgumentError, "Invalid argument set given. Driver: #{driver.class} | Path: #{path.class} | Parameters: #{parameters.class} | Configuration: #{configuration.class}"
        end

        log_chef(:debug, "Complete source/destination configuration build: '#{configs}'.")
        configs
      end

      def source_builder(driver:, parameters:, multiline: false)
        raise ArgumentError, "Expected syslog-ng driver name to be a String, got a #{driver.class}." unless driver.is_a?(String)
        raise ArgumentError, "Expected syslog-ng driver configuration attribute block to be a Hash, got a #{parameters.class}." unless parameters.is_a?(Hash)

        log_chef(:debug, "Building source/destination statement. Driver: #{driver} | Parameters: #{parameters} | Multiline: #{multiline}")
        config = []

        config.push(driver.dup.concat('('))

        if multiline
          log_chef(:debug, 'Processing as multiline.')
          config.push(format_parameter_value(parameters['path']).prepend('  ')) if parameters.key?('path')
          build_parameter_string(:source_dest, parameters['parameters']).split.each { |string| config.push(string.prepend('  ')) } if parameters.key?('parameters')
        else
          log_chef(:debug, 'Processing as single line.')
          config.push(format_parameter_value(parameters['path'])) if parameters.key?('path')
          config.push(build_parameter_string(:source_dest, parameters['parameters'])) if parameters.key?('parameters')
        end
        config.push(');')

        log_chef(:debug, "Source/destination statement build complete, result: #{config}.")

        return config if multiline
        array_join(config)
      end

      alias_method :destination_builder, :source_builder
    end
  end
end
