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
    module BlockHelpers
      include SyslogNg::Cookbook::ConfigHelpers

      SYSLOG_NG_BLOCK_TYPES ||= %i(destination filter log options parser rewrite root source).freeze

      def block_builder(type, parameters)
        raise ArgumentError, "block_builder: Expected syslog-ng block configuration to be passed as a Hash, got a #{parameters.class}" unless parameters.is_a?(Hash)

        log_chef(:debug, "Building block configuration, block config: #{parameters}.")

        block_config = []

        parameters.each do |driver, params|
          block_config.push("#{driver}(")
          block_config.push(format_parameter_value(params.delete('path')).prepend('  ')) if params.key?('path')
          build_parameter_string(type, params).split.each { |string| block_config.push(string.prepend('  ')) }
          block_config.push(');')
        end

        log_chef(:debug, "Block statement build complete, result: #{block_config}.")

        block_config
      end
    end
  end
end
