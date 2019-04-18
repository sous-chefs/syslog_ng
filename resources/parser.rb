#
# Cookbook:: syslog_ng
# Resource:: parser
#
# Copyright:: 2019, Ben Hughes <bmhughes@bmhughes.co.uk>
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

property :config_dir, String, default: '/etc/syslog-ng/parser.d'
property :cookbook, String
property :source, String
property :parser, String, required: true
property :parser_options, Hash, default: {}
property :additional_options, Hash, default: {}
property :description, String

action :create do
  template "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    source new_resource.source ? new_resource.source : 'syslog-ng/parser.conf.erb'
    cookbook new_resource.cookbook ? new_resource.cookbook : node['syslog_ng']['config']['config_template_cookbook']
    owner 'root'
    group 'root'
    mode '0755'
    sensitive new_resource.sensitive
    variables(
      name: new_resource.name,
      description: new_resource.description.nil? ? new_resource.name : new_resource.description,
      parser: new_resource.parser,
      parser_options: new_resource.parser_options,
      additional_options: new_resource.additional_options
    )
    helpers(SyslogNg::CommonHelpers)
    action :create
  end
end

action :delete do
  file "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    action :delete
  end
end
