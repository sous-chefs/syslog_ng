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

property :package_source, String, equal_to: %w(distro latest package_distro package_copr), default: 'distro'
property :packages, [String, Array]
property :remove_rsyslog, [true, false], default: true
property :repo_cleanup, [true, false], default: true

action :install do
  extend SyslogNg::InstallHelpers

  if %w(rhel centos amazon).include?(node['platform'])
    log 'Running on RHEL/CentOS/Amazon, we need epel'
    include_recipe 'yum-epel'
  end

  if new_resource.remove_rsyslog
    log 'Remove rsyslog selected'
    package 'rsyslog' do
      action :remove
    end
  else
    log 'Remove rsyslog is not selected, service will be disabled'
    service 'rsyslog' do
      action [:stop, :disable]
    end
  end

  if new_resource.package_source.eql?('distro') || new_resource.package_source.eql?('package_distro')
    log 'Installing syslog-ng from distribution package repositories'
  elsif new_resource.package_source.eql?('latest') || new_resource.package_source.eql?('package_copr')
    case node['platform_family']
    when 'fedora', 'rhel'
      log "Installing syslog-ng #{node['syslog_ng']['install']['copr_repo_version']} from COPR package repositories"

      raise 'COPR package installation is not supported on Fedora version < 28!' if platform_family?('fedora') && node['platform_version'].to_i < 28
      raise 'COPR package installation is not supported on RHEL/CentOS version < 7!' if platform_family?('rhel') && node['platform_version'].to_i < 7
      raise 'COPR installation method selected but platform is not CentOS/Fedora!' unless %w(fedora rhel).include?(node['platform_family'])

      repo_name = "syslog-ng#{node['syslog_ng']['install']['copr_repo_version'].delete('.')}"
      repo_platform_name = node['platform'].eql?('fedora') ? 'fedora' : 'epel'

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
    when 'debian'
      apt_repository 'syslog-ng-latest' do
        uri 'http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/xUbuntu_17.04'
        key 'http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/xUbuntu_17.04/Release.key'
        components ['./']
        distribution ''
        repo_name 'syslog-ng-latest'
        action :add
      end
    else
      raise "Lastest package installation not supported for platform #{node['platform']} | platform_family #{node['platform_family']}"
    end
  end

  if new_resource.repo_cleanup && %w(rhel centos fedora).include?(node['platform'])
    log 'Performing superceeded repository cleanup'
    configured_yum_repos = Dir.entries('/etc/yum.repos.d')

    configured_yum_repos.delete_if { |repo| repo == '.' || repo == '..' || !repo.include?('syslog-ng') || repo.sub('.repo', '').eql?(repo_name) }
    configured_yum_repos.each do |repo|
      log "Removing superceeded repository #{repo}"
      file "/etc/yum.repos.d/#{repo}" do
        action :delete
      end
    end
  else
    log "Superceeded repository cleanup is not available on #{node['platform']}" do
      level :warn
    end
  end

  packages = []
  if property_is_set?(:packages)
    packages.push(new_resource.packages)
  else
    latest = new_resource.package_source.eql?('latest') || new_resource.package_source.eql?('package_copr')
    ruby_block 'repo_get_packages' do
      extend SyslogNg::InstallHelpers
      block do
        packages = repo_get_packages(platform: node['platform_family'], latest: latest, copr_version: node['syslog_ng']['install']['copr_repo_version'])
        raise 'No packages found to install' if packages.empty?
        log "Found #{packages.count} packages to install"
        Chef::Log.debug("Packages to install are: #{packages.join(', ')}.")
      end
      action :run
    end
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
