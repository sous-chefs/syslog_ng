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
    def installed_version_get
      require 'mixlib/shellout'

      syslog_ng_version_cmd = Mixlib::ShellOut.new("syslog-ng --version | grep 'Installer-Version' | grep -Po '([0-9]\.?)+'")
      syslog_ng_version_cmd.run_command
      syslog_ng_version_cmd.error!

      syslog_ng_version_cmd.stdout.to_f
    end

    def repo_get_packages(platform:, copr: false)
      raise ArgumentException, "Expected platform to be a String, got a #{platform.class}." unless platform.is_a?(String)

      require 'mixlib/shellout'

      case platform
      when 'rhel', 'amazon'
        command = if copr
                    "yum -q --disablerepo=* --enablerepo=syslog-ng319 search syslog-ng | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-z]+)?)+' | uniq"
                  else
                    "yum -q search syslog-ng | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-z]+)?)+' | uniq"
                  end
        Chef::Log.debug("RHEL selected, command will be '#{command}'")
      when 'fedora'
        command = if copr
                    "dnf -q --disablerepo=* --enablerepo=syslog-ng319 search syslog-ng | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-z]+)?)+' | uniq"
                  else
                    "dnf -q search syslog-ng | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-z]+)?)+' | uniq"
                  end
        Chef::Log.debug("Fedora selected, command will be '#{command}'")
      when 'debian'
        command = "apt-cache search syslog-ng | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-z]+)?)+' | uniq"
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
        command = "rpm -qa | grep -i 'syslog-ng' | awk '{print $1}' | grep -Po '(syslog-ng)((-[a-z]+)?)+' | uniq"
        Chef::Log.debug("RHEL selected, command will be '#{command}'")
      when 'debian'
        command = "dpkg -l | grep -i 'syslog-ng' | awk '{print $2}' | grep -Po '(syslog-ng)((-[a-z]+)?)+' | uniq"
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
