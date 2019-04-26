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
  describe '.parameter_builder' do
    context('given string driver with no path or parameters') do
      it 'returns array' do
        expect(dummy_class.new.parameter_builder(driver: 'file')).to be_a(Array)
      end
    end

    context('given string driver with path and no parameters') do
      it 'returns array' do
        expect(dummy_class.new.parameter_builder(driver: 'file', path: '/file.log')).to be_a(Array)
      end
    end

    context('given string driver with path and parameters') do
      it 'returns array' do
        expect(dummy_class.new.parameter_builder(driver: 'file', path: '/file.log', parameters: { 'flush_lines' => 10, 'create-dirs' => 'yes' })).to be_a(Array)
      end
    end

    context('given array of drivers with no path or parameters') do
      it 'returns array' do
        expect(dummy_class.new.parameter_builder(driver: %w(file file))).to be_a(Array)
      end
    end

    context('given array of drivers with paths and no parameters') do
      it 'returns array' do
        expect(dummy_class.new.parameter_builder(driver: %w(file file), path: ['file1.log', 'file2.log'])).to be_a(Array)
      end
    end

    context('given array of drivers with no path and parameters') do
      it 'returns array' do
        expect(dummy_class.new.parameter_builder(driver: %w(network network), parameters: [ { 'ip' => '127.0.0.1', 'port' => '5514' }, { 'ip' => '127.0.0.1', 'port' => '5514' } ])).to be_a(Array)
      end
    end

    context('given array of drivers with paths and parameters') do
      it 'returns array' do
        expect(dummy_class.new.parameter_builder(driver: %w(file file), path: ['file1.log', 'file2.log'], parameters: [ { 'flush_lines' => 10, 'create-dirs' => 'yes' }, { 'flush_lines' => 20, 'create-dirs' => 'yes' } ])).to be_a(Array)
      end
    end

    context('given raw configuration') do
      it 'returns array' do
        expect(dummy_class.new.parameter_builder(configuration: [ { 'tcp' => { 'parameters' => { 'ip' => '127.0.0.1', 'port' => '5514' } } }, { 'udp' => { 'parameters' => { 'ip' => '127.0.0.1', 'port' => '5514' } } } ])).to be_a(Array)
      end
    end

    context('given invalid argument set') do
      it 'raises ArgumentError' do
        expect { dummy_class.new.parameter_builder() }.to raise_error(ArgumentError)
      end
    end
  end
end
