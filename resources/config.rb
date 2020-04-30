#
# Cookbook:: syslog_ng
# Resource:: config
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

property :config_file, String,
          default: lazy { "#{syslog_ng_config_dir}/syslog-ng.conf" },
          description: 'The full path to the Syslog-NG server configuration on disk'

property :cookbook, String,
          default: 'syslog_ng'

property :template, String,
          default: 'syslog-ng/syslog-ng.conf.erb'

property :owner, String,
          default: lazy { syslog_ng_user }

property :group, String,
          default: lazy { syslog_ng_group }

property :mode, String,
          default: '0640'

property :options, Hash,
          default: lazy { syslog_ng_default_config(:options) }

property :source, Hash,
          default: lazy { syslog_ng_default_config(:source) }

property :destination, Hash,
          default: lazy { syslog_ng_default_config(:destination) }

property :filter, Hash,
          default: lazy { syslog_ng_default_config(:filter) }

property :log, Hash,
          default: lazy { syslog_ng_default_config(:log) }

property :preinclude, Array,
          default: lazy { syslog_ng_default_config(:preinclude) }

property :include, Array,
          default: []

property :console_logging, [true, false]

property :config_version, [String, Float],
          default: lazy { syslog_ng_installed_version },
          coerce: proc { |p| p.is_a?(String) ? p : p.to_s },
          description: 'Configuration file version'

action :create do
  syslog_ng_config_dirs.each do |directory|
    directory directory do
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
      options: new_resource.options,
      source: new_resource.source,
      destination: new_resource.destination,
      filter: new_resource.filter,
      log: new_resource.log,
      preinclude: new_resource.preinclude,
      config_dirs: syslog_ng_config_dirs,
      include: new_resource.include,
      console_logging: new_resource.console_logging
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
