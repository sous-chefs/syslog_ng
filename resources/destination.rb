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

property :config_dir, String, default: '/etc/syslog-ng/destination.d'
property :cookbook, String
property :source, String
property :driver, [String, Array]
property :path, [String, Array]
property :parameters, [Hash, Array]
property :configuration, Array
property :description, String
property :multiline, [true, false], default: false

action :create do
  extend SyslogNg::CommonHelpers

  destination = parameter_builder(driver: new_resource.driver, path: new_resource.path, parameters: new_resource.parameters, configuration: new_resource.configuration).each do |config|
    raise "destination: Expected driver configuration to be a Hash, got #{config.class}" unless config.is_a?(Hash)
    config.each do |_, b|
      b.compact!
    end
  end

  template "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    source new_resource.source ? new_resource.source : 'syslog-ng/destination.conf.erb'
    cookbook new_resource.cookbook ? new_resource.cookbook : node['syslog_ng']['config']['config_template_cookbook']
    sensitive new_resource.sensitive
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      name: new_resource.name,
      description: new_resource.description.nil? ? new_resource.name : new_resource.description,
      destination: destination,
      multiline: new_resource.multiline
    )
    helpers(SyslogNg::DestinationHelpers)
    action :create
  end
end

action :delete do
  file "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    action :delete
  end
end
