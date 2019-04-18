#
# Cookbook:: syslog_ng
# Resource:: log
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

property :config_dir, String, default: '/etc/syslog-ng/log.d'
property :cookbook, String
property :template_source, String
property :source, [String, Array, Hash], default: []
property :filter, [String, Array, Hash], default: []
property :destination, [String, Array], default: []
property :flags, [String, Array], default: []
property :parser, [String, Array], default: []
property :description, String

action :create do
  template "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    source new_resource.template_source ? new_resource.template_source : 'syslog-ng/log.conf.erb'
    cookbook new_resource.cookbook ? new_resource.cookbook : node['syslog_ng']['config']['config_template_cookbook']
    owner 'root'
    group 'root'
    mode '0755'
    sensitive new_resource.sensitive
    variables(
      description: new_resource.description.nil? ? new_resource.name : new_resource.description,
      source: new_resource.source,
      filter: new_resource.filter,
      destination: new_resource.destination,
      flags: new_resource.flags,
      parser: new_resource.parser
    )
    helpers(SyslogNg::DestinationHelpers)
    helpers(SyslogNg::SourceHelpers)
    helpers(SyslogNg::FilterHelpers)
    action :create
  end
end

action :delete do
  file "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    action :delete
  end
end
