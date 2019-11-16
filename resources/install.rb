#
# Cookbook:: syslog_ng
# Resource:: install
#
# Copyright:: 2019, Ben Hughes <bmhughes@bmhughes.co.uk>
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

property :package_source, String, equal_to: %w(distro latest githead package_distro package_copr), default: 'distro'
property :packages, [String, Array]
property :packages_exclude, [String, Array]
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

  case new_resource.package_source
  when 'distro', 'package_distro'
    log 'Installing syslog-ng from distribution package repositories'
  when 'latest', 'package_copr'
    case node['platform_family']
    when 'fedora', 'rhel'
      log "Installing syslog-ng #{node['syslog_ng']['install']['copr_repo_version']} from COPR package repositories"

      raise 'COPR package installation is not supported on Fedora version < 28!' if platform_family?('fedora') && node['platform_version'].to_i < 28
      raise 'COPR package installation is not supported on RHEL/CentOS version < 7!' if platform_family?('rhel') && node['platform_version'].to_i < 7
      raise 'COPR installation method selected but platform is not RHEL/CentOS/Fedora!' unless %w(fedora rhel).include?(node['platform_family'])

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
      repo_name = 'syslog-ng-latest'
      repo_url = latest_apt_package_uri(node['platform'], node['platform_version'])
      apt_repository repo_name do
        uri repo_url
        key "#{repo_url}/Release.key"
        components ['./']
        distribution ''
        repo_name 'syslog-ng-latest'
        action :add
      end
    else
      raise "Lastest package installation not supported for platform #{node['platform']} | platform_family #{node['platform_family']}"
    end
  when 'githead'
    raise "Githead package installation not supported for platform #{node['platform']} | platform_family #{node['platform_family']}" unless platform_family?('fedora', 'rhel')

    repo_name = 'syslog-ng-githead'
    repo_platform_name = node['platform'].eql?('fedora') ? 'fedora' : 'epel'

    yum_repository repo_name do
      description "Copr repo for #{repo_name} owned by czanik"
      baseurl "https://copr-be.cloud.fedoraproject.org/results/czanik/syslog-ng-githead/#{repo_platform_name}-$releasever-$basearch/"
      skip_if_unavailable true
      gpgcheck true
      gpgkey 'https://copr-be.cloud.fedoraproject.org/results/czanik/syslog-ng-githead/pubkey.gpg'
      repo_gpgcheck false
      enabled true
      make_cache true
      options(
        'enabled_metadata' => '1',
        'type' => 'rpm-md'
      )
      action :create
    end
  end

  if new_resource.repo_cleanup && %w(rhel centos fedora).include?(node['platform'])
    configured_yum_repos = Dir.entries('/etc/yum.repos.d')

    configured_yum_repos.delete_if { |repo| repo == '.' || repo == '..' || !repo.include?('syslog-ng') || repo.sub('.repo', '').eql?(repo_name) }
    log "Performing superceeded repository cleanup, #{configured_yum_repos.count} repos to remove" if configured_yum_repos.count > 0
    configured_yum_repos.each do |repo|
      log "Removing superceeded repository #{repo}"
      file "/etc/yum.repos.d/#{repo}" do
        action :delete
      end
    end
  else
    log "Superceeded repository cleanup is not available on #{node['platform'].capitalize}" do
      level :warn
    end
  end

  packages = []
  if property_is_set?(:packages)
    packages.push(new_resource.packages)
  else
    source = if %w(latest package_copr githead).include?(new_resource.package_source)
               repo_name
             end
    ruby_block 'Get packages from repo' do
      extend SyslogNg::InstallHelpers
      block do
        packages = repo_get_packages(platform: node['platform_family'], source: source)
        raise 'No packages found to install' if packages.empty?
        log "Found #{packages.count} packages to install"
        Chef::Log.debug("Packages to install are: #{packages.join(', ')}.")
      end
      action :run
    end
  end

  if property_is_set?(:packages_exclude)
    ruby_block 'Exclude packages' do
      block do
        if new_resource.packages_exclude.is_a?(String)
          log "Excluding package #{new_resource.packages_exclude}"
          packages.delete_if { |package| package.match?(new_resource.packages_exclude) }
        elsif new_resource.packages_exclude.is_a?(Array)
          log "Found #{new_resource.packages_exclude.count} packages to exclude"
          new_resource.packages_exclude.each do |pkg|
            log "Excluding package #{pkg}"
            packages.delete_if { |package| package.match?(pkg) }
          end
        end
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
