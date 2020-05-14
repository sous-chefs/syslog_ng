#
# Cookbook:: syslog_ng
# Spec:: config_helpers_spec
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

describe 'SyslogNg::Cookbook::ConfigHelpers' do
  let(:dummy_class) { Class.new { include SyslogNg::Cookbook::ConfigHelpers } }

  describe 'format_parameter_value' do
    context('when given string that should be formatted') do
      it 'return correctly formatted string' do
        expect(dummy_class.new.format_parameter_value('formatme')).to be_a(String) & eql('"formatme"')
      end
    end

    context('when given string that should not formatted') do
      it 'return correctly unformatted string' do
        expect(dummy_class.new.format_parameter_value('yes')).to be_a(String) & eql('yes')
        expect(dummy_class.new.format_parameter_value('port(123)')).to be_a(String) & eql('port(123)')
      end
    end

    context('when given IP address as string') do
      it 'return unchanged IP address as string' do
        expect(dummy_class.new.format_parameter_value('192.0.2.1')).to be_a(String) & eql('192.0.2.1')
      end
    end

    context('when given Integer') do
      it 'return unchanged Integer' do
        expect(dummy_class.new.format_parameter_value(123)).to be_a(Integer) & eql(123)
      end
    end
  end
end
