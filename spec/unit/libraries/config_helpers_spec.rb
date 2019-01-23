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
  describe '.config_srcdst_driver_map sources' do
    context('given driver with no parameters') do
      it 'returns config string' do
        expect(dummy_class.new.config_srcdst_driver_map('system', {})).to be_a(String)
        expect(dummy_class.new.config_srcdst_driver_map('system', {})).to eql('system();')
      end
    end

    context('given driver with parameters') do
      it 'returns config string' do
        expect(dummy_class.new.config_srcdst_driver_map('system', {})).to be_a(String)
        expect(dummy_class.new.config_srcdst_driver_map('udp', 'parameters' => { 'ip' => '0.0.0.0', 'port' => 514 })).to eql('udp(ip(0.0.0.0) port(514));')
      end
    end

    context('given driver with parameters as an array as string') do
      it 'returns config string' do
        expect(dummy_class.new.config_srcdst_driver_map('network', {})).to be_a(String)
        expect(dummy_class.new.config_srcdst_driver_map('network', 'parameters' => ['ip("127.0.0.1")', 'port(5514)'])).to eql('network(ip("127.0.0.1") port(5514));')
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
        expect(dummy_class.new.config_srcdst_driver_map('network', {})).to be_a(String)
        expect(dummy_class.new.config_srcdst_driver_map('network', param)).to eql('network(ip(127.0.0.1) port(5614));')
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
        expect(dummy_class.new.config_srcdst_driver_map('network', {})).to be_a(String)
        expect(dummy_class.new.config_srcdst_driver_map('network', param)).to eql('network(ip(127.0.0.1) port("5614 5714"));')
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
        expect(dummy_class.new.config_srcdst_driver_map('internal', {})).to be_a(String)
        expect(dummy_class.new.config_srcdst_driver_map('internal', param)).to eql('internal(program-override("testing") use_fqdn(yes) tags("test_tag_01", "test_tag_02"));')
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
        expect(dummy_class.new.config_srcdst_driver_map('network', param)).to be_a(String)
        expect(dummy_class.new.config_srcdst_driver_map('network', param)).to eql('network(transport("tls") ip(127.0.0.1) port(9999) tls(peer-verify("required-trusted") key-file("/etc/syslog-ng/tls/syslog-ng.key") cert-file("/etc/syslog-ng/tls/syslog-ng.crt")));')
      end
    end
  end

  describe '.config_srcdst_driver_map destinations' do
    context('given driver with no parameters and a path') do
      it 'returns valid config string' do
        expect(dummy_class.new.config_srcdst_driver_map('file', 'path' => '/dev/console')).to be_a(String)
        expect(dummy_class.new.config_srcdst_driver_map('file', 'path' => '/dev/console')).to eql('file("/dev/console");')
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
        expect(dummy_class.new.config_srcdst_driver_map('file', param)).to be_a(String)
        expect(dummy_class.new.config_srcdst_driver_map('file', param)).to eql('file("/var/log/maillog" flush_lines(10));')
      end
    end

    context('given string') do
      param = {
        'path' => '/var/log/maillog',
        'parameters' => 'flush_lines(10)',
      }

      it 'returns valid config string' do
        expect(dummy_class.new.config_srcdst_driver_map('file', param)).to be_a(String)
        expect(dummy_class.new.config_srcdst_driver_map('file', param)).to eql('file("/var/log/maillog" flush_lines(10));')
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
            'facility' => %w(mail authpriv cron),
          },
        },
      }

      it 'returns valid config string' do
        expect(dummy_class.new.config_filter_map(param)).to be_a(String)
        expect(dummy_class.new.config_filter_map(param)).to eql('level(info..emerg) and not (facility(mail) or facility(authpriv) or facility(cron))')
      end
    end

    context('given inplicit _and_ filter') do
      param = {
        'container' => {
          'facility' => %w(mail authpriv cron),
        },
      }

      it 'returns valid config string with _and_ present' do
        expect(dummy_class.new.config_filter_map(param)).to be_a(String)
        expect(dummy_class.new.config_filter_map(param)).to eql('(facility(mail) and facility(authpriv) and facility(cron))')
      end
    end

    context('given contained string') do
      param = {
        'container' => {
          'facility' => 'mail',
        },
      }

      it 'returns valid config string with _and_ present' do
        expect(dummy_class.new.config_filter_map(param)).to be_a(String)
        expect(dummy_class.new.config_filter_map(param)).to eql('(facility(mail))')
      end
    end

    context('given multiple contained strings') do
      param = {
        'container_outside' => {
          'operator' => 'and',
          'container_1' => {
            'facility' => 'mail',
          },
          'container_2' => {
            'facility' => 'cron',
          },
        },
      }

      it 'returns valid config string with _and_ present' do
        expect(dummy_class.new.config_filter_map(param)).to be_a(String)
        expect(dummy_class.new.config_filter_map(param)).to eql('((facility(mail)) and (facility(cron)))')
      end
    end

    context('given contained integer') do
      param = {
        'container_outside' => {
          'operator' => 'and',
          'container_1' => {
            'port' => 514,
          },
        },
      }

      it 'raises RuntimeError' do
        expect { dummy_class.new.config_filter_map(param) }.to raise_exception(RuntimeError)
      end
    end

    context('given hash array key') do
      param = {
        'facility' => %w(mail authpriv cron),
      }

      it 'returns valid config string' do
        expect(dummy_class.new.config_filter_map(param)).to be_a(String)
        expect(dummy_class.new.config_filter_map(param)).to eql('facility(mail) facility(authpriv) facility(cron)')
      end
    end

    context('given array') do
      param = [
        'facility(mail)',
        'facility(authpriv)',
        'facility(cron)',
      ]

      it 'returns valid config string' do
        expect(dummy_class.new.config_filter_map(param)).to be_a(String)
        expect(dummy_class.new.config_filter_map(param)).to eql('facility(mail) facility(authpriv) facility(cron)')
      end
    end

    context('given string') do
      param = 'level(emerg)'

      it 'returns valid config string' do
        expect(dummy_class.new.config_filter_map(param)).to be_a(String)
        expect(dummy_class.new.config_filter_map(param)).to eql('level(emerg)')
      end
    end

    context('invalid filter') do
      param = {
        'invalidfilter': 'bollocks',
      }

      it 'raises ArgumentError' do
        expect { dummy_class.new.config_filter_map(param) }.to raise_exception(ArgumentError)
      end
    end
  end
end
