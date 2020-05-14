#
# Cookbook:: syslog_ng
# Resource:: config
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

property :config_file, String,
          default: lazy { "#{syslog_ng_config_dir}/syslog-ng.conf" },
          description: 'The path to the Syslog-NG server configuration on disk'

property :config_directory, String,
          default: lazy { syslog_ng_config_dir }

property :config_version, [String, Float],
          default: lazy { syslog_ng_installed_version },
          coerce: proc { |p| p.is_a?(String) ? p : p.to_s },
          description: 'Configuration file version'

property :cookbook, String,
          default: 'syslog_ng',
          description: 'Cookbook to source configuration file template from'

property :template, String,
          default: 'syslog-ng/syslog-ng.conf.erb',
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

property :blocks, Hash,
          description: 'SyslogNG reusable configuration blocks'

property :options, Hash,
          default: lazy { syslog_ng_default_config(:options) },
          description: 'Syslog-NG server global options'

property :source, Hash,
          default: lazy { syslog_ng_default_config(:source) },
          description: 'Syslog-NG server global log sources'

property :destination, Hash,
          default: lazy { syslog_ng_default_config(:destination) },
          description: 'Syslog-NG server global log destinations'

property :filter, Hash,
          default: lazy { syslog_ng_default_config(:filter) },
          description: 'Syslog-NG server global log filters '

property :log, Hash,
          default: lazy { syslog_ng_default_config(:log) },
          description: 'Syslog-NG server global logs'

property :preinclude, Array,
          default: lazy { syslog_ng_default_config(:preinclude) },
          description: 'Files to include at the beginning of the global configuration file'

property :include, Array,
          default: [],
          description: 'Files to include in the global configuration file'

property :blocks, [Hash, Array],
          description: 'Array of blocks to reference without parameters or a Hash of blocks to reference with parameters'

action :create do
  syslog_ng_config_dirs.each do |directory|
    directory "#{new_resource.config_directory}/#{directory}" do
      owner new_resource.owner
      group new_resource.group

      action :create
    end
  end

  template new_resource.config_file do
    cookbook new_resource.cookbook
    source new_resource.template

    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    sensitive new_resource.sensitive

    variables(
      version: new_resource.config_version,
      blocks: new_resource.blocks,
      options: new_resource.options,
      source: new_resource.source,
      destination: new_resource.destination,
      filter: new_resource.filter,
      log: new_resource.log,
      preinclude: new_resource.preinclude,
      config_dirs: syslog_ng_config_dirs,
      include: new_resource.include
    )
    helpers(SyslogNg::Cookbook::SourceDestinationHelpers)
    helpers(SyslogNg::Cookbook::FilterHelpers)

    action :create
  end
end

action :delete do
  file new_resource.name do
    action :delete
  end
end
