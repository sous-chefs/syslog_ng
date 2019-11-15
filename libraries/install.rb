#
# Cookbook:: syslog_ng
# Library:: install
#
# Copyright:: 2018, Ben Hughes <bmhughes@bmhughes.co.uk>, All Rights Reserved.
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

module SyslogNg
  module InstallHelpers
    def latest_apt_package_uri
      platform = node['platform'].capitalize
      platform = platform.prepend('x') if platform?('ubuntu')

      platform_version = case node['platform']
                         when 'debian'
                           v = version.to_f.floor.to_s
                           v.concat('.0') if version.to_i < 10
                           v
                         when 'ubuntu'
                           node['platform_version'].to_s
                         end

      "http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/#{platform}_#{platform_version}"
    end

    def installed_version_get
      require 'mixlib/shellout'

      syslog_ng_version_cmd = Mixlib::ShellOut.new("syslog-ng --version | grep 'Installer-Version' | grep -Po '([0-9]\.?)+'")
      syslog_ng_version_cmd.run_command
      syslog_ng_version_cmd.error!

      /[0-9]+.[0-9]+/.match(syslog_ng_version_cmd.stdout).to_s
    end

    def repo_get_packages(platform:, source: nil)
      raise ArgumentException, "Expected platform to be a String, got a #{platform.class}." unless platform.is_a?(String)

      require 'mixlib/shellout'

      case platform
      when 'rhel', 'amazon'
        command = if !source.nil?
                    "yum -q --disablerepo=* --enablerepo=#{source} search syslog-ng | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-zA-Z0-9]+)?)+' | sort -u"
                  else
                    "yum -q search syslog-ng | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-zA-Z0-9]+)?)+' | sort -u"
                  end
        Chef::Log.debug("RHEL selected, command will be '#{command}'")
      when 'fedora'
        command = if !source.nil?
                    "dnf -q --disablerepo=* --enablerepo=#{source} search syslog-ng | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-zA-Z0-9]+)?)+' | sort -u"
                  else
                    "dnf -q search syslog-ng | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-zA-Z0-9]+)?)+' | sort -u"
                  end
        Chef::Log.debug("Fedora selected, command will be '#{command}'")
      when 'debian'
        command = if !source.nil?
                    'apt-cache search syslog-ng | grep -i "syslog-ng" | awk "{print $1}" | grep -Po "(syslog-ng)" | sort -u'
                  else
                    "apt-cache search syslog-ng | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-zA-Z0-9]+)?)+' | sort -u"
                  end
        Chef::Log.debug("Debian selected, command will be '#{command}'")
      else
        raise "repo_get_packages: Unknown platform. Given platform: #{platform}."
      end

      package_search = Mixlib::ShellOut.new(command)
      package_search.run_command
      package_search.error!
      packages = package_search.stdout.split(/\n+/)

      packages
    end

    def installed_get_packages(platform:)
      raise ArgumentException, "Expected platform to be a String, got a #{platform.class}." unless platform.is_a?(String)

      require 'mixlib/shellout'

      case platform
      when 'rhel', 'fedora', 'amazon'
        command = "rpm -qa | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-z]+)?)+' | sort -u"
        Chef::Log.debug("RHEL selected, command will be '#{command}'")
      when 'debian'
        command = "dpkg -l | grep -i 'syslog-ng' | awk '{print $2}' | grep -Po '(syslog-ng)((-[a-z]+)?)+' | sort -u"
        Chef::Log.debug("Debian selected, command will be '#{command}'")
      else
        raise "installed_get_packages: Unknown platform. Given platform: #{platform}."
      end

      package_search = Mixlib::ShellOut.new(command)
      package_search.run_command
      package_search.error!
      packages = package_search.stdout.split(/\n+/)

      packages
    end
  end
end
