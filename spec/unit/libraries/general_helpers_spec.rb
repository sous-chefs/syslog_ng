#
# Cookbook:: syslog_ng
# Spec:: config_helpers_spec
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

describe 'SyslogNg::Cookbook::ConfigHelpers' do
  let(:dummy_class) { Class.new { include SyslogNg::Cookbook::GeneralHelpers } }

  describe '.syslog_ng_installed_version' do
    context('when called') do
      let(:shellout) do
        double(run_command: nil, error!: nil, stdout: '', stderr: '', exitstatus: 0, live_stream: '')
      end

      it 'return syslog-ng version as a String' do
        allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
        allow(shellout).to receive(:error!).and_return(nil)
        allow(shellout).to receive(:stdout).and_return('3.18\n1')

        expect(dummy_class.new.syslog_ng_installed_version).to be_a(String)
        expect(dummy_class.new.syslog_ng_installed_version).to eq('3.18')
      end
    end
  end
end
