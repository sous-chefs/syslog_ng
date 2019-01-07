#
# Cookbook:: syslog_ng
# Spec:: config_helpers_spec
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

describe 'SyslogNg::ConfigHelpers' do
  let(:dummy_class) { Class.new { include SyslogNg::ConfigHelpers } }
  describe '.config_source_driver_map' do
    context('given driver with no parameters') do
      it 'returns config string' do
        expect(dummy_class.new.config_source_driver_map('system', {})).to be_a(String)
        expect(dummy_class.new.config_source_driver_map('system', {})).to eql('system();')
      end
    end

    context('given driver with parameters') do
      it 'returns config string' do
        expect(dummy_class.new.config_source_driver_map('system', {})).to be_a(String)
        expect(dummy_class.new.config_source_driver_map('udp', 'ip' => '0.0.0.0', 'port' => 514)).to eql('udp(ip("0.0.0.0") port(514));')
      end
    end
  end

  describe '.config_destination_driver_map' do
    context('given driver with no parameters and a path') do
      it 'returns valid config string' do
        expect(dummy_class.new.config_destination_driver_map('file', 'path' => '/dev/console')).to be_a(String)
        expect(dummy_class.new.config_destination_driver_map('file', 'path' => '/dev/console')).to eql('file("/dev/console");')
      end
    end

    context('given driver with parameters and a path') do
      param = {
        'path' => '/var/log/maillog',
        'parameters' => {
          'flush_lines' => 10,
        },
      }

      it 'returns valid config string' do
        expect(dummy_class.new.config_destination_driver_map('file', param)).to be_a(String)
        expect(dummy_class.new.config_destination_driver_map('file', param)).to eql('file("/var/log/maillog" flush_lines(10));')
      end
    end
  end

  describe '.config_filter_map' do
    context('given basic filter') do
      param = {
        'facility' => 'kern',
      }
      it 'returns valid config string' do
        expect(dummy_class.new.config_filter_map(param)).to be_a(String)
        expect(dummy_class.new.config_filter_map(param)).to eql('facility(kern)')
      end
    end

    context('given complex filter') do
      param = {
        'level' => 'info..emerg',
        'and_not' => {
          'container' => {
            'operator' => 'or',
            'facility' => [
              'mail',
              'authpriv',
              'cron',
            ],
          },
        },
      }

      it 'returns valid config string' do
        expect(dummy_class.new.config_filter_map(param)).to be_a(String)
        expect(dummy_class.new.config_filter_map(param)).to eql('level(info..emerg) and not (facility(mail) or facility(authpriv) or facility(cron))')
      end
    end
  end
end
