#
# Cookbook:: syslog_ng
# Resource:: install
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
# See the License for the spcific language governing prmissions and
# limitations under the License.

include SyslogNg::Cookbook::InstallHelpers

property :packages, [String, Array],
          default: lazy { default_packages(repo_include: package_repository, repo_exclude: package_repository_exclude) },
          coerce: proc { |p| p.is_a?(Array) ? p : [p] }

property :packages_exclude, [String, Array],
          coerce: proc { |p| p.is_a?(Array) ? p : [p] },
          default: []

property :package_repository, [String, Array],
          description: 'Install packages from a specific repository/repositories'

property :package_repository_exclude, [String, Array],
          coerce: proc { |p| p.is_a?(Array) ? p : [p] },
          description: 'Exclude repository when installing packages'

action_class do
  def do_package_action(action)
    log "Excluding packages: #{new_resource.packages_exclude.join(', ')}." if new_resource.packages_exclude
    package 'syslog-ng' do
      package_name lazy { new_resource.packages.delete_if { |package| new_resource.packages_exclude.include?(package) } }
      action action
    end
  end
end

action :install do
  if platform?('redhat', 'centos', 'amazon')
    log 'Running on RHEL/CentOS/Amazon, we need EPEL.'
    include_recipe 'yum-epel'
  end

  do_package_action(action)
end

action :upgrade do
  do_package_action(action)
end

action :remove do
  do_package_action(action)
end
