#
# Cookbook:: syslog_ng
# Spec:: destination_helpers_spec
#
# Copyright:: Ben Hughes <bmhughes@bmhughes.co.uk>
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

describe 'SyslogNg::Cookbook::SourceDestinationHelpers' do
  let(:dummy_class) { Class.new { include SyslogNg::Cookbook::SourceDestinationHelpers } }
  describe 'source_dest_config_builder' do
    context('given driver with no path or parameters') do
      it 'returns array' do
        expect(dummy_class.new.source_dest_config_builder(driver: ['file'], path: [], parameters: {})).to be_a(Array)
      end
    end

    context('given driver with path and no parameters') do
      it 'returns array' do
        expect(dummy_class.new.source_dest_config_builder(driver: ['file'], path: ['/file.log'], parameters: {})).to be_a(Array)
      end
    end

    context('given driver with path and parameters') do
      it 'returns array' do
        expect(dummy_class.new.source_dest_config_builder(driver: ['file'], path: ['/file.log'], parameters: [{ 'flush_lines' => 10, 'create-dirs' => 'yes' }])).to be_a(Array)
      end
    end

    context('given array of drivers with no path or parameters') do
      it 'returns array' do
        expect(dummy_class.new.source_dest_config_builder(driver: %w(file file), path: [], parameters: {})).to be_a(Array)
      end
    end

    context('given array of drivers with paths and no parameters') do
      it 'returns array' do
        expect(dummy_class.new.source_dest_config_builder(driver: %w(file file), path: ['file1.log', 'file2.log'], parameters: {})).to be_a(Array)
      end
    end

    context('given array of drivers with no path and parameters') do
      it 'returns array' do
        expect(dummy_class.new.source_dest_config_builder(driver: %w(network network), path: [], parameters: [ { 'ip' => '127.0.0.1', 'port' => '5514' }, { 'ip' => '127.0.0.1', 'port' => '5514' } ])).to be_a(Array)
      end
    end

    context('given array of drivers with paths and parameters') do
      it 'returns array' do
        expect(dummy_class.new.source_dest_config_builder(driver: %w(file file), path: ['file1.log', 'file2.log'], parameters: [ { 'flush_lines' => 10, 'create-dirs' => 'yes' }, { 'flush_lines' => 20, 'create-dirs' => 'yes' } ])).to be_a(Array)
      end
    end

    context('given raw configuration') do
      it 'returns array' do
        expect(dummy_class.new.source_dest_config_builder(configuration: [ { 'tcp' => { 'parameters' => { 'ip' => '127.0.0.1', 'port' => '5514' } } }, { 'udp' => { 'parameters' => { 'ip' => '127.0.0.1', 'port' => '5514' } } } ])).to be_a(Array)
      end
    end

    context('given invalid argument set') do
      it 'raises ArgumentError' do
        expect { dummy_class.new.source_dest_config_builder() }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'destination_builder destinations' do
    context('given driver with no parameters and a path') do
      it 'returns valid config string' do
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: { 'path' => '/dev/console' })).to be_a(String)
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: { 'path' => '/dev/console' })).to eql('file("/dev/console");')
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
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: param)).to be_a(String)
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: param)).to eql('file("/var/log/maillog" flush_lines(10));')
      end
    end

    context('given string') do
      param = {
        'path' => '/var/log/maillog',
        'parameters' => 'flush_lines(10)',
      }

      it 'returns valid config string' do
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: param)).to be_a(String)
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: param)).to eql('file("/var/log/maillog" flush_lines(10));')
      end
    end
  end

  describe 'source_builder sources' do
    context('given driver with no parameters') do
      it 'returns config string' do
        expect(dummy_class.new.source_builder(driver: 'system', parameters: {})).to be_a(String)
        expect(dummy_class.new.source_builder(driver: 'system', parameters: {})).to eql('system();')
      end
    end

    context('given driver with parameters') do
      it 'returns config string' do
        expect(dummy_class.new.source_builder(driver: 'system', parameters: {})).to be_a(String)
        expect(dummy_class.new.source_builder(driver: 'udp', parameters: { 'parameters' => { 'ip' => '0.0.0.0', 'port' => 514 } })).to eql('udp(ip(0.0.0.0) port(514));')
      end
    end

    context('given driver with parameters as an array as string') do
      it 'returns config string' do
        expect(dummy_class.new.source_builder(driver: 'network', parameters: {})).to be_a(String)
        expect(dummy_class.new.source_builder(driver: 'network', parameters: { 'parameters' => ['ip("127.0.0.1")', 'port(5514)'] })).to eql('network(ip("127.0.0.1") port(5514));')
      end
    end

    context('given driver with parameters as an array with non-string') do
      param = {
        'parameters' => {
          'ip' => [
            '127.0.0.1',
          ],
          'port' => [
            5614,
          ],
        },
      }

      it 'returns config string' do
        expect(dummy_class.new.source_builder(driver: 'network', parameters: {})).to be_a(String)
        expect(dummy_class.new.source_builder(driver: 'network', parameters: param)).to eql('network(ip(127.0.0.1) port(5614));')
      end
    end

    context('given driver with parameter as an array with multiple non-string') do # There is no valid config I can see that would use this but it validates a code path.
      param = {
        'parameters' => {
          'ip' => [
            '127.0.0.1',
          ],
          'port' => [
            5614,
            5714,
          ],
        },
      }

      it 'returns config string' do
        expect(dummy_class.new.source_builder(driver: 'network', parameters: {})).to be_a(String)
        expect(dummy_class.new.source_builder(driver: 'network', parameters: param)).to eql('network(ip(127.0.0.1) port(5614 5714));')
      end
    end

    context('given driver with parameters as a hash containing an array') do
      param = {
        'parameters' => {
          'program-override' => 'testing',
          'use_fqdn' => 'yes',
          'tags' => %w(test_tag_01 test_tag_02),
        },
      }

      it 'returns config string' do
        expect(dummy_class.new.source_builder(driver: 'internal', parameters: {})).to be_a(String)
        expect(dummy_class.new.source_builder(driver: 'internal', parameters: param)).to eql('internal(program-override("testing") use_fqdn(yes) tags("test_tag_01", "test_tag_02"));')
      end
    end

    context('given nested source driver config') do
      param = {
        'parameters' => {
          'transport' => 'tls',
          'ip' => '127.0.0.1',
          'port' => 9999,
          'tls' => {
            'peer-verify' => 'required-trusted',
            'key-file' => '/etc/syslog-ng/tls/syslog-ng.key',
            'cert-file' => '/etc/syslog-ng/tls/syslog-ng.crt',
          },
        },
      }
      it 'returns config string' do
        expect(dummy_class.new.source_builder(driver: 'network', parameters: param)).to be_a(String)
        expect(dummy_class.new.source_builder(driver: 'network', parameters: param)).to eql('network(transport("tls") ip(127.0.0.1) port(9999) tls(peer-verify("required-trusted") key-file("/etc/syslog-ng/tls/syslog-ng.key") cert-file("/etc/syslog-ng/tls/syslog-ng.crt")));')
      end
    end

    context('given driver with parameters and multiline set') do
      it 'returns config string' do
        expect(dummy_class.new.source_builder(driver: 'system', parameters: {}, multiline: true)).to be_a(Array)
        expect(dummy_class.new.source_builder(driver: 'udp', parameters: { 'parameters' => { 'ip' => '0.0.0.0', 'port' => 514 } }, multiline: true)).to eql(['udp(', '  ip(0.0.0.0)', '  port(514)', ');'])
      end
    end
  end
end
