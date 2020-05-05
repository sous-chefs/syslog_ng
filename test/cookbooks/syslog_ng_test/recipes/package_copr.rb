#
# Cookbook:: syslog_ng_test
# Recipe:: package_copr
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

case node['platform_family']
when 'rhel', 'centos'
  yum_repository 'copr:copr.fedorainfracloud.org:czanik:syslog-ng326' do
    baseurl "https://download.copr.fedorainfracloud.org/results/czanik/syslog-ng326/epel-#{node['platform_version'].to_i}-$basearch/"
    skip_if_unavailable true
    gpgcheck true
    gpgkey 'https://download.copr.fedorainfracloud.org/results/czanik/syslog-ng326/pubkey.gpg'
    repo_gpgcheck false
    enabled true

    action :create
  end
when 'fedora'
  yum_repository 'copr:copr.fedorainfracloud.org:czanik:syslog-ng326' do
    baseurl 'https://download.copr.fedorainfracloud.org/results/czanik/syslog-ng326/fedora-$releasever-$basearch/'
    skip_if_unavailable true
    gpgcheck true
    gpgkey 'https://download.copr.fedorainfracloud.org/results/czanik/syslog-ng326/pubkey.gpg'
    repo_gpgcheck false
    enabled true

    action :create
  end
end

syslog_ng_package 'syslog-ng' do
  package_repository 'copr:copr.fedorainfracloud.org:czanik:syslog-ng326'
  packages_exclude %w(syslog-ng-debuginfo syslog-ng-devel)
  action :install
end
