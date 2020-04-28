#
# Cookbook:: syslog_ng
# Spec:: destination_helpers_spec
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

describe 'SyslogNg::Cookbook::SourceHelpers' do
  let(:dummy_class) { Class.new { include SyslogNg::Cookbook::SourceHelpers } }
  describe '.destination_builder destinations' do
    context('given driver with no parameters and a path') do
      it 'returns valid config string' do
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: { 'path' => '/dev/console' })).to be_a(String)
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: { 'path' => '/dev/console' })).to eql('file("/dev/console");')
      end
    end

    context('given driver with parameters and a path') do
      param = {
        'path' => '/var/log/maillog',
        'parameters' => {
          'flush_lines' => 10,
        },
      }

      it 'returns valid config string' do
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: param)).to be_a(String)
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: param)).to eql('file("/var/log/maillog" flush_lines(10));')
      end
    end

    context('given string') do
      param = {
        'path' => '/var/log/maillog',
        'parameters' => 'flush_lines(10)',
      }

      it 'returns valid config string' do
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: param)).to be_a(String)
        expect(dummy_class.new.destination_builder(driver: 'file', parameters: param)).to eql('file("/var/log/maillog" flush_lines(10));')
      end
    end
  end
end
