#
# Cookbook:: syslog_ng
# Resource:: config_global
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

property :cookbook, String
property :source, String
property :options, Hash
property :source, Hash
property :destination, Hash
property :filter, Hash
property :log, Hash
property :preinclude, Array
property :include, Array
property :console_logging, [true, false]
property :perform_config_test, [true, false], default: true

action :create do
  extend SyslogNg::InstallHelpers

  template new_resource.name do
    cookbook new_resource.cookbook.nil? ? node['syslog_ng']['config']['config_template_cookbook'] : new_resource.cookbook
    source new_resource.source.nil? ? node['syslog_ng']['config']['config_template_template'] : new_resource.source
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      lazy do
        {
          version: installed_version_get,
          options: new_resource.options.nil? ? node['syslog_ng']['config']['options'] : new_resource.options,
          source: new_resource.source.nil? ? node['syslog_ng']['config']['source'] : new_resource.source,
          destination: new_resource.destination.nil? ? node['syslog_ng']['config']['destination'] : new_resource.destination,
          filter: new_resource.filter.nil? ? node['syslog_ng']['config']['filter'] : new_resource.filter,
          log: new_resource.log.nil? ? node['syslog_ng']['config']['log'] : new_resource.log,
          preinclude: new_resource.preinclude.nil? ? node['syslog_ng']['config']['preinclude'] : new_resource.include,
          include: new_resource.include.nil? ? node['syslog_ng']['config']['include'] : new_resource.include,
          console_logging: new_resource.console_logging.nil? ? node['syslog_ng']['config']['console_logging'] : new_resource.console_logging,
        }
      end
    )
    helpers(SyslogNg::ConfigHelpers)
    notifies :run, 'execute[syslog-ng-global-config-test]', :delayed if new_resource.perform_config_test
    notifies :restart, 'service[syslog-ng]', :delayed
    action :create
  end

  node['syslog_ng']['config']['config_dirs'].each do |name, directory|
    directory name do
      owner 'root'
      group 'root'
      mode '0755'
      path directory
      action :create
    end
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
  file new_resource.name do
    action :delete
  end
end
