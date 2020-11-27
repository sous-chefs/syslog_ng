#
# Cookbook:: syslog_ng
# Library:: resource
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

module SyslogNg
  module Cookbook
    module ResourceHelpers
      def config_file
        "#{new_resource.config_dir}/#{new_resource.name}.conf"
      end

      def config_file_disabled
        "#{config_file}.disabled"
      end

      def enable_config_file
        with_run_context(:root) do
          edit_resource(:ruby_block, "Enable #{new_resource.declared_type} #{new_resource.name}") do
            block do
              ::File.rename(config_file_disabled, config_file)
            end

            action :run
          end
        end
      end

      def disable_config_file
        with_run_context(:root) do
          edit_resource(:ruby_block, "Disable #{new_resource.declared_type} #{new_resource.name}") do
            block do
              ::File.rename(config_file, config_file_disabled)
            end

            action :run
          end
        end
      end
    end
  end
end
