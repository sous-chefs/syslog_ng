#
# Cookbook:: syslog_ng
# Library:: helpers
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

require 'mixlib/shellout'

module SyslogNg
  module Cookbook
    module GeneralHelpers
      def default_syslog_ng_user
        'root'
      end

      def default_syslog_ng_group
        'root'
      end

      def syslog_ng_config_dir
        '/etc/syslog-ng'
      end

      def syslog_ng_config_file
        'syslog-ng.conf'
      end

      def syslog_ng_config_dirs
        [
          '/etc/syslog-ng/conf.d',
          '/etc/syslog-ng/destination.d',
          '/etc/syslog-ng/filter.d',
          '/etc/syslog-ng/log.d',
          '/etc/syslog-ng/parser.d',
          '/etc/syslog-ng/rewrite.d',
          '/etc/syslog-ng/source.d',
          '/etc/syslog-ng/template.d',
        ]
      end

      def syslog_ng_installed_version
        require 'mixlib/shellout'

        version_cmd = Mixlib::ShellOut.new("syslog-ng --version | grep 'Installer-Version' | grep -Po '([0-9]\.?)+'")
        version_cmd.run_command
        version_cmd.error!

        /[0-9]+.[0-9]+/.match(version_cmd.stdout).to_s
      end

      def syslog_ng_default_config(section)
        case section
        when :options
          {
            'flush_lines' => 0,
            'time_reopen' => 10,
            'log_fifo_size' => 1000,
            'chain_hostnames' => 'off',
            'use_dns' => 'no',
            'use_fqdn' => 'no',
            'create_dirs' => 'no',
            'keep_hostname' => 'yes',
          }
        when :source
          {
            's_sys' => {
              'system' => {},
              'internal' => {},
            },
          }
        when :destination
          {
            'd_cons' => {
              'file' => {
                'path' => '/dev/console',
              },
            },
            'd_mesg' => {
              'file' => {
                'path' => '/var/log/messages',
              },
            },
            'd_auth' => {
              'file' => {
                'path' => '/var/log/secure',
              },
            },
            'd_mail' => {
              'file' => {
                'path' => '/var/log/maillog',
                'parameters' => {
                  'flush_lines' => 10,
                },
              },
            },
            'd_spol' => {
              'file' => {
                'path' => '/var/log/spooler',
              },
            },
            'd_boot' => {
              'file' => {
                'path' => '/var/log/boot.log',
              },
            },
            'd_cron' => {
              'file' => {
                'path' => '/var/log/cron',
              },
            },
            'd_kern' => {
              'file' => {
                'path' => '/var/log/kern',
              },
            },
            'd_mlal' => {
              'usertty' => {
                'path' => '*',
              },
            },
          }
        when :filter
          {
            'f_kernel' => {
              'facility' => 'kern',
            },
            'f_default' => {
              'level' => 'info..emerg',
              'and_not' => {
                'container' => {
                  'operator' => 'or',
                  'facility' => %w(mail authpriv cron),
                },
              },
            },
            'f_auth' => {
              'facility' => 'authpriv',
            },
            'f_mail' => {
              'facility' => 'mail',
            },
            'f_emergency' => {
              'level' => 'emerg',
            },
            'f_news' => {
              'facility' => 'uucp',
              'or' => {
                'container' => {
                  'operator' => 'and',
                  'facility' => 'news',
                  'level' => 'crit..emerg',
                },
              },
            },
            'f_boot' => {
              'facility' => 'local7',
            },
            'f_cron' => {
              'facility' => 'cron',
            },
          }
        when :log
          {
            'kern' => {
              'source' => [
                's_sys',
              ],
              'filter' => [
                'f_kernel',
              ],
              'destination' => [
                'd_kern',
              ],
            },
            'mesg' => {
              'source' => [
                's_sys',
              ],
              'filter' => [
                'f_default',
              ],
              'destination' => [
                'd_mesg',
              ],
            },
            'auth' => {
              'source' => [
                's_sys',
              ],
              'filter' => [
                'f_auth',
              ],
              'destination' => [
                'd_auth',
              ],
            },
            'mail' => {
              'source' => [
                's_sys',
              ],
              'filter' => [
                'f_mail',
              ],
              'destination' => [
                'd_mail',
              ],
            },
            'mlal' => {
              'source' => [
                's_sys',
              ],
              'filter' => [
                'f_emergency',
              ],
              'destination' => [
                'd_mlal',
              ],
            },
            'spol' => {
              'source' => [
                's_sys',
              ],
              'filter' => [
                'f_news',
              ],
              'destination' => [
                'd_spol',
              ],
            },
            'boot' => {
              'source' => [
                's_sys',
              ],
              'filter' => [
                'f_boot',
              ],
              'destination' => [
                'd_boot',
              ],
            },
            'cron' => {
              'source' => [
                's_sys',
              ],
              'filter' => [
                'f_cron',
              ],
              'destination' => [
                'd_cron',
              ],
            },
          }
        when :preinclude
          [
            'scl.conf',
          ]
        end
      end
    end
  end
end
