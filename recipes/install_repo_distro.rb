#
# Cookbook:: syslog_ng
# Recipe:: install_repo_distro
#
# Copyright:: 2018, Ben Hughes
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

platform_family = node['platform_family']
packages = case platform_family
           when 'rhel', 'fedora'
             node['syslog_ng']['install']['rhel']['repo_packages_base']
             platform_family = 'rhel'
           when 'debian'
             node['syslog_ng']['install']['debian']['repo_packages_base']
           else
             log 'Platform family not matched' do
               level :error
             end
             raise ArgumentError
           end

if node['syslog_ng']['install']['all_modules']
  packages = (node['syslog_ng']['install']['rhel']['repo_packages_base'] + node['syslog_ng']['install'][platform_family]['distro_repo_packages_modules'])
end

package 'syslog_ng' do
  package_name packages
  action :upgrade
end
