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

action_class do
  def do_service_action(resource_action)
    with_run_context(:root) do
      edit_resource(:execute, "Run pre service #{resource_action} Syslog-NG configuration test.") do
        command "#{platform_family?('amazon') ? '/sbin/syslog-ng' : '/usr/sbin/syslog-ng'} -s"
        only_if { new_resource.config_test && %i(start restart reload).include?(resource_action) && ::File.exist?(new_resource.config_file) }

        action :nothing
      end

      edit_resource(:service, new_resource.service_name) do
        notifies :run, "execute[Run pre service #{resource_action} Syslog-NG configuration test.]", :before

        action :nothing
        delayed_action resource_action
      end
    end
  end
end

action :start do
  do_service_action(action)
end

action :stop do
  do_service_action(action)
end

action :restart do
  do_service_action(action)
end

action :reload do
  do_service_action(action)
end

action :enable do
  do_service_action(action)
end

action :disable do
  do_service_action(action)
end
