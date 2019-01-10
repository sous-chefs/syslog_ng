#
# Cookbook:: syslog_ng
# Spec:: filter_spec
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

describe 'syslog_ng_test::filter' do
  context 'With test recipe, on CentOS 7.6.1804' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.6.1804')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates destinations' do
      expect(chef_run).to create_syslog_ng_filter('f_test')

      filter = chef_run.syslog_ng_filter('f_test')
      expect(filter).to notify('execute[syslog-ng-config-test]').to(:run).delayed
      expect(filter).to notify('service[syslog-ng]').to(:reload).delayed
    end
  end

  context 'With test recipe, on Fedora 29' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'fedora', version: '29')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates destinations' do
      expect(chef_run).to create_syslog_ng_filter('f_test')

      filter = chef_run.syslog_ng_filter('f_test')
      expect(filter).to notify('execute[syslog-ng-config-test]').to(:run).delayed
      expect(filter).to notify('service[syslog-ng]').to(:reload).delayed
    end
  end
end
