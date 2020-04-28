#
# Cookbook:: syslog_ng
# Spec:: destination_spec
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

describe 'syslog_ng_config_global' do
  step_into :syslog_ng_config_global
  platform 'centos'

  context 'create syslog-ng global config file' do
    recipe do
      syslog_ng_config_global '/etc/syslog-ng/syslog-ng.conf'
    end

    it 'Creates the global config file correctly' do
      is_expected.to render_file('/etc/syslog-ng/syslog-ng.conf')
        .with_content(/@include "scl.conf/)
        .with_content(/source s_sys {/)
        .with_content(/destination d_mesg {/)
        .with_content(/level(info..emerg) and not (facility(mail) or facility(authpriv) or facility(cron));/)
    end
  end
end
