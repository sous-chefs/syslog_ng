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

describe 'syslog_ng_test::config_global' do
  platforms = {
    'CentOS' => '8',
    'Fedora' => '30',
    'Amazon' => '2',
    'Debian' => '10',
    'Ubuntu' => '18.04',
  }

  platforms.each do |platform, version|
    context "With test recipe, on #{platform} #{version}" do
      let(:chef_run) do
        runner = ChefSpec::SoloRunner.new(platform: platform.dup.downcase!, version: version)
        runner.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'creates global config file' do
        expect(chef_run).to create_syslog_ng_config_global('/etc/syslog-ng/syslog-ng.conf')

        config_test = chef_run.execute('syslog-ng-config-test')
        expect(config_test).to do_nothing

        expect(chef_run).to start_service('syslog-ng')
        expect(chef_run).to enable_service('syslog-ng')
      end
    end
  end
end
