#
# Cookbook:: syslog_ng
# Spec:: filter_spec
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

require 'spec_helper'

describe 'syslog_ng_source' do
  step_into :syslog_ng_source
  platform 'centos'

  context 'create syslog-ng source config file' do
    recipe do
      syslog_ng_source 's_test_syslog' do
        driver 'syslog'
        parameters(
          'ip' => '127.0.0.1',
          'port' => '3381',
          'max-connections' => 100,
          'log_iw_size' => 10000,
          'use_dns' => :persist_only
        )
        action :create
      end
    end

    it 'Creates the source config file correctly' do
      is_expected.to render_file('/etc/syslog-ng/source.d/s_test_syslog.conf')
        .with_content(/# Source - s_test_syslog/)
        .with_content(/source s_test_syslog {/)
        .with_content(/syslog\(ip\(127.0.0.1\) port\(3381\) max-connections\(100\) log_iw_size\(10000\) use_dns\(persist_only\)\);/)
    end
  end
end
