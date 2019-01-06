#
# Cookbook:: syslog_ng
# Recipe:: install_repo_copr
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

repo_name = "syslog_ng#{node['syslog_ng']['install_copr_version'].delete('.')}"

yum_repository repo_name do
  description "Copr repo for #{repo_name} owned by czanik"
  baseurl "https://copr-be.cloud.fedoraproject.org/results/czanik/#{repo_name}/fedora-$releasever-$basearch/"
  skip_if_unavailable true
  gpgcheck true
  gpgkey "https://copr-be.cloud.fedoraproject.org/results/czanik/#{repo_name}/pubkey.gpg"
  repo_gpgcheck false
  enabled true
  options(
    'enabled_metadata' => '1',
    'type' => 'rpm-md'
  )
  action :create
end

packages = node['syslog_ng']['install']['rhel']['repo_packages_base']

if node['syslog_ng']['install']['all_modules']
  packages = (node['syslog_ng']['install']['rhel']['repo_packages_base'] + node['syslog_ng']['install']['rhel']['copr_repo_packages_modules'])
end

package 'syslog_ng' do
  package_name packages
  action :upgrade
end
