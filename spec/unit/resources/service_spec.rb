#
# Cookbook:: syslog_ng
# Spec:: filter_spec
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

describe 'syslog_ng_source' do
  step_into :syslog_ng_service
  platform 'centos'

  context 'configure syslog-ng service' do
    recipe do
      syslog_ng_service 'syslog-ng' do
        action %i(enable start)
      end
    end

    before do
      dbl = double(run_command: double(error!: nil), stdout: 'expected output')
      allow(Mixlib::ShellOut).to receive(:new).with('/usr/sbin/syslog-ng -s').and_return(dbl)
    end

    describe 'enables and starts service' do
      it { is_expected.to enable_service('syslog-ng') }
      it { is_expected.to start_service('syslog-ng') }
    end
  end
end
