#
# Cookbook:: syslog_ng
# Spec:: log_spec
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

describe 'syslog_ng_log' do
  step_into :syslog_ng_log
  platform 'centos'

  context 'create syslog-ng log config file' do
    recipe do
      syslog_ng_log 'l_test' do
        source 's_test_tcp'
        filter 'f_test'
        destination 'd_test_file'
        rewrite 'r_test_ip'
        action :create
      end
    end

    it 'Creates the filter config file correctly' do
      is_expected.to render_file('/etc/syslog-ng/log.d/l_test.conf')
        .with_content(/# Log - l_test/)
        .with_content(/log {/)
        .with_content(/source\(s_test_tcp\);/)
        .with_content(/rewrite\(r_test_ip\);/)
    end
  end
end
