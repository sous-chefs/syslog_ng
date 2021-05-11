#
# Cookbook:: syslog_ng
# Resource:: block
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

unified_mode true

include SyslogNg::Cookbook::GeneralHelpers

property :config_dir, String,
          default: lazy { "#{syslog_ng_config_dir}/block.d" },
          description: 'Directory to create configuration file in'

property :cookbook, String,
          default: 'syslog_ng',
          description: 'Cookbook to source configuration file template from'

property :template, String,
          default: 'syslog-ng/block.conf.erb',
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

property :type, Symbol,
          equal_to: SyslogNg::Cookbook::BlockHelpers::SYSLOG_NG_BLOCK_TYPES

property :parameters, Hash,
          description: 'Parameters to be used within the block'

property :definition, Hash,
          description: 'Definition of the block contents'

action_class do
  include SyslogNg::Cookbook::ResourceHelpers
end

action :create do
  template config_file do
    cookbook new_resource.cookbook
    source new_resource.template

    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    sensitive new_resource.sensitive

    variables(
      name: new_resource.name,
      description: new_resource.description || new_resource.name,
      type: new_resource.type,
      parameters: new_resource.parameters,
      definition: new_resource.definition
    )
    helpers(SyslogNg::Cookbook::BlockHelpers)

    action :create
  end
end

action :delete do
  file config_file do
    action :delete
  end
end

action :enable do
  converge_by "Disable #{new_resource.declared_type} #{new_resource.name}" do
    enable_config_file
  end if ::File.exist?(config_file_disabled)
end

action :disable do
  converge_by "Disable #{new_resource.declared_type} #{new_resource.name}" do
    disable_config_file
  end if ::File.exist?(config_file)
end
