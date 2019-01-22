#
# Cookbook:: syslog_ng
# Spec:: destination_spec
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

require 'spec_helper'

describe 'syslog_ng_test::install' do
  tests = {
    'syslog_ng_test::package_distro' => {
      'CentOS' => '7.6.1804',
      'Fedora' => '29',
      'Amazon' => '2',
      'Debian' => '9.6',
      'Ubuntu' => '18.04',
    },
    'syslog_ng_test::package_copr' => {
      'CentOS' => '7.6.1804',
      'Fedora' => '29',
    },
  }

  tests.each do |resource, platforms|
    platforms.each do |platform, version|
      context "With test recipe, on #{platform} #{version}" do
        let(:chef_run) do
          # for a complete list of available platforms and versions see:
          # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
          runner = ChefSpec::ServerRunner.new(platform: platform.dup.downcase!, version: version)
          runner.converge(resource)
        end

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end

        it 'installs syslog-ng' do
          expect(chef_run).to install_syslog_ng_install('')
        end
      end
    end
  end
end
