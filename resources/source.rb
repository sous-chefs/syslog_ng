#
# Cookbook:: syslog_ng
# Resource:: source
#
# Copyright:: 2020, Ben Hughes <bmhughes@bmhughes.co.uk>
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

include SyslogNg::Cookbook::GeneralHelpers

property :config_dir, String,
          default: lazy { "#{syslog_ng_config_dir}/source.d" }

property :cookbook, String,
          default: 'syslog_ng'

property :template, String,
          default: 'syslog-ng/source.conf.erb'

property :owner, String,
          default: lazy { syslog_ng_user }

property :group, String,
          default: lazy { syslog_ng_group }

property :mode, String,
          default: '0640'

property :driver, [String, Array],
          coerce: proc { |p| p.is_a?(Array) ? p : [p] }

property :path, [String, Array],
          default: [],
          coerce: proc { |p| p.is_a?(Array) ? p : [p] }

property :parameters, [Hash, Array],
          default: {},
          coerce: proc { |p| p.is_a?(Array) ? p : [p] }

property :configuration, [Hash, Array],
          coerce: proc { |p| p.is_a?(Array) ? p : [p] }

property :description, String

property :multiline, [true, false],
          default: false

action_class do
  include SyslogNg::Cookbook::ConfigHelpers
end

action :create do
  template "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    cookbook new_resource.cookbook
    source new_resource.template

    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    sensitive new_resource.sensitive

    variables(
      name: new_resource.name,
      description: new_resource.description.nil? ? new_resource.name : new_resource.description,
      source: parameter_builder(driver: new_resource.driver, path: new_resource.path, parameters: new_resource.parameters, configuration: new_resource.configuration),
      multiline: new_resource.multiline
    )
    helpers(SyslogNg::Cookbook::SourceDestinationHelpers)

    action :create
  end
end

action :delete do
  file "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    action :delete
  end
end
