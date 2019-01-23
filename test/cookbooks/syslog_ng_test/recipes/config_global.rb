#
# Cookbook:: test
# Recipe:: package_distro
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

syslog_ng_config_global '/etc/syslog-ng/syslog-ng.conf' do
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :restart, 'service[syslog-ng]', :delayed
  action :create
end

case node['platform_family']
when 'amazon'
  execute 'syslog-ng-config-test' do
    command '/sbin/syslog-ng -s'
    action :nothing
  end
else
  execute 'syslog-ng-config-test' do
    command '/usr/sbin/syslog-ng -s'
    action :nothing
  end
end

service 'syslog-ng' do
  action :nothing
end
