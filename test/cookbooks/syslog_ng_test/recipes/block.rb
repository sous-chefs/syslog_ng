#
# Cookbook:: syslog_ng_test
# Recipe:: block
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

with_run_context :root do
  find_resource(:syslog_ng_service, 'syslog-ng') do
    action :nothing
  end
end

syslog_ng_block 'b_test_tcp_source_block' do
  type :source
  parameters(
    'localport' => :empty,
    'flags' => '""'
  )
  definition(
    'network' => {
      'port' => '`localport`',
      'transport' => 'tcp',
      'flags' => '`flags`',
    }
  )
  notifies :restart, 'syslog_ng_service[syslog-ng]', :delayed
  action :create
end

syslog_ng_block 'b_test_file_destination_block' do
  type :destination
  parameters(
    'file' => :empty
  )
  definition(
    'file' => {
      'path' => '`file`',
      'flush_lines' => 10,
      'create-dirs' => 'yes',
    }
  )
  notifies :restart, 'syslog_ng_service[syslog-ng]', :delayed
  action :create
end
