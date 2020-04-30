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

describe 'syslog_ng_filter' do
  step_into :syslog_ng_filter
  platform 'centos'

  context 'create syslog-ng filter config file' do
    recipe do
      syslog_ng_filter 'f_test' do
        parameters(
          'container' => {
            'operator' => 'or',
            'facility' => %w(mail authpriv cron),
          }
        )
        action :create
      end
    end

    it 'Creates the filter config file correctly' do
      is_expected.to render_file('/etc/syslog-ng/filter.d/f_test.conf')
        .with_content(/# Filter - f_test/)
        .with_content(/filter f_test {/)
        .with_content(/\(facility\(mail\) or facility\(authpriv\) or facility\(cron\)\);/)
    end
  end
end
