#
# Cookbook:: syslog_ng
# Resource:: source
#
# Copyright:: 2018, Ben Hughes <bmhughes@bmhughes.co.uk>
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

property :perform_config_test, [true, false], default: true

action :enable do
  execute 'syslog-ng-config-test' do
    command '/usr/sbin/syslog-ng -s'
    only_if { new_resource.perform_config_test }
    action :run
  end

  service 'syslog-ng' do
    action [:enable, :start]
  end
end

action :disable do
  service 'syslog-ng' do
    action [:stop, :disable]
  end
end

action :start do
  !find_resource(:execute, 'syslog-ng-config-test').run_action(:run) if new_resource.perform_config_test
  !find_resource(:service, 'syslog-ng').run_action(:reload)
end

action :start do
  !find_resource(:service, 'syslog-ng').run_action(:stop)
end

action :reload do
  !find_resource(:execute, 'syslog-ng-config-test').run_action(:run) if new_resource.perform_config_test
  !find_resource(:service, 'syslog-ng').run_action(:reload)
end

action :reload do
  !find_resource(:execute, 'syslog-ng-config-test').run_action(:run) if new_resource.perform_config_test
  !find_resource(:service, 'syslog-ng').run_action(:restart)
end
