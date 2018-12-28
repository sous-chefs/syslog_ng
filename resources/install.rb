#
# Cookbook:: syslog_ng
# Resource:: install
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

property :package_source, String, equal_to: %w(package_distro package_copr)
property :package_all_modules, [true, false], default: true
property :remove_rsyslog, [true, false], default: true

action :install do
  packages = []

  # RHEL/CentOS need EPEL installed
  if %w(rhel centos).include?(node['platform'])
    log 'Running on RHEL/CentOS, we need epel'
    include_recipe 'yum-epel'
  end

  case new_resource.package_source
  when 'package_distro'
    log 'Installing syslog-ng from distribution package repositories'

    platform_family = node['platform_family']
    case platform_family
    when 'rhel', 'fedora'
      log 'RHEL/Fedora platform'
      platform_family = 'rhel' # Override for Fedora
      packages << node['syslog_ng']['install']['rhel']['package_distro_base']
    when 'debian'
      log 'Debian platform'
      packages << node['syslog_ng']['install']['debian']['package_distro_base']
    else
      log 'Platform family not matched' do
        level :error
      end
      raise ArgumentError
    end

    if new_resource.package_all_modules
      packages << node['syslog_ng']['install'][platform_family]['package_distro_modules']
    end
  when 'package_copr'
    log "Installing syslog-ng #{node['syslog_ng']['install']['rhel']['copr_repo_version']} from COPR package repositories"
    unless %w(fedora centos).include?(node['platform'])
      log 'COPR installation method selected but platform is not CentOS/Fedora!' do
        level :error
      end
      break
    end
    repo_name = "syslog-ng#{node['syslog_ng']['install']['rhel']['copr_repo_version'].delete('.')}"
    repo_platform_name = (node['platform'] == 'fedora') ? 'fedora' : 'epel'

    yum_repository repo_name do
      description "Copr repo for #{repo_name} owned by czanik"
      baseurl "https://copr-be.cloud.fedoraproject.org/results/czanik/#{repo_name}/#{repo_platform_name}-$releasever-$basearch/"
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

    packages << node['syslog_ng']['install']['rhel']['package_distro_base']

    if new_resource.package_all_modules
      packages << node['syslog_ng']['install']['rhel']['package_copr_modules']
    end
  end

  package 'syslog_ng' do
    package_name packages
    notifies :reload, 'ohai[Reload ohai]', :immediately
    action :upgrade
  end

  ohai 'Reload ohai' do
    plugin 'packages'
    action :nothing
  end
end

action :remove do
  package 'syslog_ng' do
    package_name 'syslog-ng'
    action :remove
  end
end
