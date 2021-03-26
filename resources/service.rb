#
# Cookbook:: syslog_ng
# Resource:: service
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
# See the License for the spcific language governing prmissions and
# limitations under the License.

include SyslogNg::Cookbook::GeneralHelpers

property :service_name, String,
          default: lazy { default_syslog_ng_service_name },
          description: 'The service name to perform actions upon'

property :config_file, String,
          default: lazy { "#{syslog_ng_config_dir}/syslog-ng.conf" },
          description: 'The path to the Syslog-NG server configuration on disk'

property :config_test, [true, false],
          default: true,
          description: 'Perform a configuration file test before performing service action'

property :config_test_fail_action, Symbol,
          equal_to: %i(raise log),
          default: :raise,
          description: 'Action to perform upon configuration test failure.'

action_class do
  def do_service_action(resource_action)
    if %i(start restart reload).include?(resource_action)
      begin
        if new_resource.config_test
          log "Performing pre-#{resource_action} configuration test"
          cmd = Mixlib::ShellOut.new("#{syslog_ng_binary} -s")
          cmd.run_command.error!
          Chef::Log.info("Configuration test passed, creating #{new_resource.service_name} #{new_resource.declared_type} resource with action #{resource_action}")
        else
          Chef::Log.info("Configuration test disabled, creating #{new_resource.service_name} #{new_resource.declared_type} resource with action #{resource_action}")
        end

        declare_resource(:service, new_resource.service_name.delete_suffix('.service')).action(resource_action)
      rescue Mixlib::ShellOut::ShellCommandFailed
        if new_resource.config_test_fail_action.eql?(:log)
          Chef::Log.error("Configuration test failed, #{new_resource.service_name} #{resource_action} action aborted!\n\nError\n-----\n#{cmd.stderr}")
        else
          raise "Configuration test failed, #{new_resource.service_name} #{resource_action} action aborted!\n\nError\n-----\n#{cmd.stderr}"
        end
      end
    else
      declare_resource(:service, new_resource.service_name.delete_suffix('.service')).action(resource_action)
    end
  end
end

%i(start stop restart reload enable disable).each do |action_type|
  send(:action, action_type) { do_service_action(action) }
end
