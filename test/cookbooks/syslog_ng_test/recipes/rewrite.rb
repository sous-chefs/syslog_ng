#
# Cookbook:: test
# Recipe:: rewrite
#
# Copyright:: 2019, Ben Hughes <bmhughes@bmhughes.co.uk>
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

syslog_ng_rewrite 'r_test_ip' do
  function 'subst'
  match 'IP'
  replacement 'IP-Address'
  value 'MESSAGE'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_rewrite 'r_test_set' do
  function 'set'
  replacement 'myhost'
  value 'HOST'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_rewrite 'r_test_set_additional' do
  function 'set'
  replacement '$MESSAGE suffix'
  value 'HOST'
  additional_options 'on-error' => 'fallback-to-string'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_rewrite 'r_test_unset' do
  function 'unset'
  value 'HOST'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_rewrite 'r_test_groupunset' do
  function 'groupunset'
  values '.SDATA.*'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_rewrite 'r_test_groupset_single' do
  function 'groupset'
  field 'nobody'
  values '.USER.*'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_rewrite 'r_test_groupset_array' do
  function 'groupset'
  field 'myhost'
  values %w(HOST FULLHOST)
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_rewrite 'r_test_set_condition' do
  function 'set'
  replacement 'myhost'
  value 'HOST'
  condition 'program("myapplication")'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_rewrite 'r_test_set_tag' do
  function 'set-tag'
  tags 'tag-to-add-1'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_rewrite 'r_test_clear_tag' do
  function 'clear-tag'
  tags 'tag-to-delete'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end

syslog_ng_rewrite 'r_test_credit_card_mask' do
  function 'credit-card-mask'
  value 'cc-field'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
