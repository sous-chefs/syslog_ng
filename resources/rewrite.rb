#
# Cookbook:: syslog_ng
# Resource:: rewrite
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
# See the License for the specific language governing permissions and
# limitations under the License.

include SyslogNg::Cookbook::GeneralHelpers

property :config_dir, String,
          default: lazy { "#{syslog_ng_config_dir}/rewrite.d" },
          description: 'Directory to create configuration file in'

property :cookbook, String,
          default: 'syslog_ng',
          description: 'Cookbook to source configuration file template from'

property :template, String,
          default: 'syslog-ng/rewrite.conf.erb',
          description: 'Template to use to generate the configuration file'

property :owner, String,
          default: lazy { default_syslog_ng_user },
          description: 'Owner of the generated configuration file'

property :group, String,
          default: lazy { default_syslog_ng_group },
          description: 'Group of the generated configuration file'

property :mode, String,
          default: '0640',
          description: 'Filemode of the generated configuration file'

property :description, String,
          description: 'Unparsed description to add to the configuration file'

property :function, String,
          equal_to: SyslogNg::Cookbook::RewriteHelpers::SYSLOG_NG_REWRITE_OPERATORS,
          description: 'Rewrite function'

property :match, String,
          description: 'String or regular expression to find'

property :replacement, String,
          description: 'Replacement string'

property :field, String,
          description: 'Field to match against'

property :value, String,
          description: 'Value to apply rewrite action to (Field name)'

property :values, [String, Array],
          description: 'Values to apply rewrite action to (Field name or Glob pattern)'

property :flags, [String, Array],
          description: 'Flag(s) to apply'

property :tags, String,
          description: 'Tags to apply'

property :condition, String,
          description: 'Condition which must be satisfied for the rewrite to be applied'

property :additional_options, Hash,
          default: {},
          description: 'Additional options for rewrite function'

property :configuration, [Hash, Array],
          coerce: proc { |p| p.is_a?(Array) ? p : [p] },
          description: 'Hash or Array of Hash containing raw rewrite(s) configuration'

property :blocks, [Hash, Array],
          description: 'Array of blocks to reference without parameters or a Hash of blocks to reference with parameters'

action_class do
  include SyslogNg::Cookbook::RewriteHelpers
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
      description: new_resource.description || new_resource.name,
      rewrite: rewrite_config_builder,
      blocks: new_resource.blocks
    )
    helpers(SyslogNg::Cookbook::RewriteHelpers)

    action :create
  end
end

action :delete do
  file "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    action :delete
  end
end
