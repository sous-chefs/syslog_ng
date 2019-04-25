#
# Cookbook:: test
# Recipe:: destination
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

with_run_context :root do
  find_resource(:execute, 'syslog-ng-config-test') do
    command '/sbin/syslog-ng -s'
    action :nothing
  end
  find_resource(:service, 'syslog-ng') do
    action :nothing
  end
end

syslog_ng_destination 'd_test_file' do
  driver 'file'
  path '/var/log/test.log'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_destination 'd_test_file_params' do
  driver 'file'
  path '/var/log/test/test_params.log'
  parameters(
    'flush_lines' => 10,
    'create-dirs' => 'yes'
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_destination 'd_test_mongo_params' do
  driver 'mongodb'
  parameters(
    'servers' => '127.0.0.1:27017',
    'database' => 'syslog',
    'collection' => 'messages',
    'value-pairs' => {
      'scope' => %w(selected-macros nv-pairs sdata),
    }
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_destination 'd_test_multi_file' do
  configuration(
    [
      {
        'file' => {
          'path' => '/var/log/test_file_1.log',
          'parameters' => {
            'flush_lines' => 10,
            'create-dirs' => 'yes',
          },
        },
      },
      {
        'file' => {
          'path' => '/var/log/test_file_2.log',
          'parameters' => {
            'flush_lines' => 20,
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

syslog_ng_destination 'd_test_multi_file_multiline' do
  configuration(
    [
      {
        'file' => {
          'path' => '/var/log/test_multiline_1.log',
          'parameters' => {
            'flush_lines' => 10,
            'create-dirs' => 'yes',
          },
        },
      },
      {
        'file' => {
          'path' => '/var/log/test_multiline_2.log',
          'parameters' => {
            'flush_lines' => 20,
            'create-dirs' => 'yes',
          },
        },
      },
    ]
  )
  multiline true
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
