#
# Cookbook:: syslog-ng
# Recipe:: install
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

service 'rsyslog' do
  action [ :stop, :disable ]
  only_if { node['syslog-ng']['install']['remove_rsyslog'] }
end

package 'rsyslog' do
  action :remove
  only_if { node['syslog-ng']['install']['remove_rsyslog'] }
end

include_recipe 'yum-epel' if %w(rhel centos).include?(node['platform'])

case node['syslog-ng']['install']['method']
when 'repo_distro'
  include_recipe '::install_repo_distro'
when 'repo_copr'
  include_recipe '::install_repo_copr'
else
  raise ArgumentError
end

# service 'syslog-ng' do
#   action [ :enable, :start ]
#   supports status: true, restart: true, reload: true
# end
