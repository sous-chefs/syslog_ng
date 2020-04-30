#
# Cookbook:: syslog_ng
# Resource:: log
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
          default: lazy { "#{syslog_ng_config_dir}/log.d" }

property :cookbook, String,
          default: 'syslog_ng'

property :template, String,
          default: 'syslog-ng/log.conf.erb'

property :owner, String,
          default: lazy { syslog_ng_user }

property :group, String,
          default: lazy { syslog_ng_group }

property :mode, String,
          default: '0640'

property :source, [String, Array, Hash],
          default: []

property :filter, [String, Array, Hash],
          default: []

property :destination, [String, Array],
          default: []

property :flags, [String, Array],
          default: []

property :parser, [String, Array],
          default: []

property :rewrite, [String, Array],
          default: []

property :junction, [Hash, Array],
          default: []

property :description, String

action :create do
  template "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    cookbook new_resource.cookbook
    source new_resource.template

    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    sensitive new_resource.sensitive

    variables(
      description: new_resource.description ? new_resource.description : new_resource.name,
      source: new_resource.source,
      filter: new_resource.filter,
      destination: new_resource.destination,
      flags: new_resource.flags,
      parser: new_resource.parser,
      rewrite: new_resource.rewrite,
      junction: new_resource.junction
    )
    helpers(SyslogNg::Cookbook::SourceDestinationHelpers)
    helpers(SyslogNg::Cookbook::FilterHelpers)

    action :create
  end
end

action :delete do
  file "#{new_resource.config_dir}/#{new_resource.name}.conf" do
    action :delete
  end
end
