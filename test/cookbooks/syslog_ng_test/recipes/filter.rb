#
# Cookbook:: test
# Recipe:: filter
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

syslog_ng_filter 'f_test' do
  parameters(
    'container' => {
      'operator' => 'or',
      'facility' => %w(mail authpriv cron),
    }
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_filter 'f_test_contained' do
  parameters(
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
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_filter 'f_test_array_and' do
  parameters(
    'container' => {
      'facility' => %w(mail authpriv cron),
    }
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_filter 'f_test_array_or' do
  parameters(
    'container' => {
      'operator' => 'or',
      'facility' => %w(mail authpriv cron),
    }
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_filter 'f_test_raw_string' do
  parameters 'host("example") and match("deny" value("MESSAGE"))'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_filter 'f_test_raw_string_array' do
  parameters ['host("example1")', 'or host("example2")', 'or (host("example3") and not match("test" value("NOT_ME_MESSAGE")))']
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
