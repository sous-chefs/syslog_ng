#
# Cookbook:: syslog_ng
# Spec:: destination_helpers_spec
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

require 'spec_helper'

describe 'SyslogNg::CommonHelpers' do
  let(:dummy_class) { Class.new { include SyslogNg::CommonHelpers } }
  describe '.parameter_defined?' do
    context('given parameter string') do
      it 'returns true' do
        expect(dummy_class.new.parameter_defined?('parameter')).to be_a(TrueClass)
      end
    end

    context('given nil') do
      it 'returns false' do
        expect(dummy_class.new.parameter_defined?(nil)).to be_a(FalseClass)
      end
    end

    context('given empty array or hash') do
      it 'returns false' do
        expect(dummy_class.new.parameter_defined?([])).to be_a(FalseClass)
        expect(dummy_class.new.parameter_defined?({})).to be_a(FalseClass)
      end
    end
  end
end
