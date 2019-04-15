#
# Cookbook:: syslog_ng
# Resource:: install
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

property :package_source, String, equal_to: %w(package_distro package_copr), default: 'package_distro'
property :remove_rsyslog, [true, false], default: true
property :repo_cleanup, [true, false], default: true

action :install do
  extend SyslogNg::InstallHelpers
  packages = []

  # RHEL/CentOS need EPEL installed
  if %w(rhel centos amazon).include?(node['platform'])
    log 'Running on RHEL/CentOS/Amazon, we need epel'
    include_recipe 'yum-epel'
  end

  if new_resource.remove_rsyslog
    log 'Remove rsyslog selected, removing'
    package 'rsyslog' do
      action :remove
    end
  else
    log 'Remove rsyslog is not selected, service will be disabled'
    service 'rsyslog' do
      action [:stop, :disable]
    end
  end

  case new_resource.package_source
  when 'package_distro'
    log 'Installing syslog-ng from distribution package repositories'
    copr = false
  when 'package_copr'
    log "Installing syslog-ng #{node['syslog_ng']['install']['copr_repo_version']} from COPR package repositories"
    copr = true

    case node['platform_family']
    when 'fedora'
      unless node['platform_version'].to_i >= 28
        Chef::Log.error('COPR package installation is not supported on Fedora version < 28!')
        raise 'COPR package installation is not supported on Fedora version < 28!'
      end
    when 'rhel'
      unless node['platform_version'].to_i >= 7
        Chef::Log.error('COPR package installation is not supported on RHEL/CentOS version < 7!')
        raise 'COPR package installation is not supported on RHEL/CentOS version < 7!'
      end
    else
      log 'COPR installation method selected but platform is not CentOS/Fedora!' do
        level :error
      end
      raise 'COPR installation method selected but platform is not CentOS/Fedora!'
    end

    repo_name = "syslog-ng#{node['syslog_ng']['install']['copr_repo_version'].delete('.')}"
    repo_platform_name = (node['platform'] == 'fedora') ? 'fedora' : 'epel'

    yum_repository repo_name do
      description "Copr repo for #{repo_name} owned by czanik"
      baseurl "https://copr-be.cloud.fedoraproject.org/results/czanik/#{repo_name}/#{repo_platform_name}-$releasever-$basearch/"
      skip_if_unavailable true
      gpgcheck true
      gpgkey "https://copr-be.cloud.fedoraproject.org/results/czanik/#{repo_name}/pubkey.gpg"
      repo_gpgcheck false
      enabled true
      make_cache true
      options(
        'enabled_metadata' => '1',
        'type' => 'rpm-md'
      )
      action :create
    end

    if new_resource.repo_cleanup
      log 'Performing superceeded repository cleanup'
      configured_yum_repos = Dir.entries('/etc/yum.repos.d')

      configured_yum_repos.each do |repo|
        next if repo == '.' || repo == '..' || !repo.include?('syslog-ng') || repo.sub('.repo', '').eql?(repo_name)
        log "Removing superceeded repository #{repo}"
        file "/etc/yum.repos.d/#{repo}" do
          action :delete
        end
      end
    end
  end

  ruby_block 'repo_get_packages' do
    extend SyslogNg::InstallHelpers
    block do
      packages = repo_get_packages(platform: node['platform_family'], copr: copr, copr_version: node['syslog_ng']['install']['copr_repo_version'])
      raise 'No packages found to install' if packages.empty?
      log "Found #{packages.count} packages to install"
      Chef::Log.debug("Packages to install are: #{packages.join(', ')}.")
    end
    action :run
  end

  package 'syslog_ng' do
    package_name lazy { packages }
    notifies :reload, 'ohai[Reload ohai]', :immediately
    action :upgrade
  end

  ohai 'Reload ohai' do
    plugin 'packages'
    action :nothing
  end
end

action :remove do
  ruby_block 'installed_get_packages' do
    extend SyslogNg::InstallHelpers
    block do
      packages = installed_get_packages(platform: node['platform_family'])
      log "Found #{packages.count} packages to remove"
      Chef::Log.debug("Packages to remove are: #{packages.join(', ')}.")
    end
    action :run
  end

  package 'syslog_ng' do
    package_name lazy { packages }
    action :remove
  end
end
