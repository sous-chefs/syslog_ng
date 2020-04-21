#
# Cookbook:: syslog_ng_test
# Recipe:: log
#
# Copyright:: 2020, Ben Hughes <bmhughes@bmhughes.co.uk>
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

with_run_context :root do
  find_resource(:execute, 'syslog-ng-config-test') do
    command '/sbin/syslog-ng -s'
    action :nothing
  end
  find_resource(:service, 'syslog-ng') do
    action :nothing
  end
end

syslog_ng_log 'l_test' do
  source 's_test_tcp'
  filter 'f_test'
  destination 'd_test_file'
  rewrite 'r_test_ip'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_log 'l_test_2' do
  source 's_test_tcp'
  filter 'f_test'
  destination 'd_test_file'
  rewrite %w(r_test_ip r_test_set)
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_log 'l_test_embedded' do
  source(
    [
      'tcp' => {
        'parameters' => {
          'ip' => '127.0.0.1',
          'port' => '5516',
        },
      },
      'udp' => {
        'parameters' => {
          'ip' => '127.0.0.1',
          'port' => '5516',
        },
      },
    ]
  )
  filter(
    'container_outside' => {
      'operator' => 'and',
      'container_1' => {
        'facility' => 'mail',
      },
      'container_2' => {
        'operator' => 'or',
        'facility' => %w(cron authpriv),
      },
    }
  )
  destination(
    [
      {
        'file' => {
          'path' => '/var/log/embedded_test/test_file_1.log',
          'parameters' => {
            'flush_lines' => 10,
            'create-dirs' => 'yes',
          },
        },
      },
      {
        'file' => {
          'path' => '/var/log/embedded_test/test_file_2.log',
          'parameters' => {
            'flush_lines' => 100,
            'create-dirs' => 'yes',
          },
        },
      },
    ]
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_log 'l_test_junction' do
  source(
    [
      'tcp' => {
        'parameters' => {
          'ip' => '127.0.0.1',
          'port' => '5520',
          'flags' => 'no-parse',
        },
      },
    ]
  )
  destination(
    [
      {
        'file' => {
          'path' => '/var/log/junction_test/test_file_junction.log',
          'parameters' => {
            'flush_lines' => 10,
            'create-dirs' => 'yes',
          },
        },
      },
    ]
  )
  junction(
    [
      {
        'filter' => 'f_test',
        'parser' => {
          'parser' => 'syslog-parser',
        },
      },
      {
        'filter' => 'f_test_contained',
      },
    ]
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
