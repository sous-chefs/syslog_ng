#
# Cookbook:: syslog_ng
# Resource:: destination
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
property :source, String
property :cookbook, String
property :driver, String
property :path, String
property :parameters, Hash, default: {}
property :config_dir, String, default: '/etc/syslog-ng/destinations.d'

action :create do
  destination = {
    new_resource.name => {
      new_resource.driver => {
        'path' => new_resource.path,
        'parameters' => new_resource.parameters,
      },
    },
  }

  template "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    source new_resource.source ? new_resource.source : 'syslog-ng/destination.conf.erb'
    cookbook new_resource.cookbook ? new_resource.cookbook : node['syslog_ng']['config']['config_template_cookbook']
    owner 'root'
    group 'root'
    mode '0755'
    sensitive new_resource.sensitive
    variables(
      destination: destination
    )
    helpers(SyslogNg::ConfigHelpers)
    notifies :run, 'execute[syslog-ng-global-config-test]', :delayed if new_resource.perform_config_test
    notifies :restart, 'service[syslog-ng]', :delayed
    action :create
  end

  execute 'syslog-ng-global-config-test' do
    command '/usr/sbin/syslog-ng -s'
    action :nothing
  end

  service 'syslog-ng' do
    action :nothing
  end
end

action :delete do
  file "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    notifies :restart, 'service[syslog-ng]', :delayed
    action :delete
  end

  find_resource!(:execute, 'syslog-ng-global-config-test') do
  end.run_action(:run) if new_resource.perform_config_test

  find_resource!(:service, 'syslog-ng') do
  end.run_action(:restart)
end
