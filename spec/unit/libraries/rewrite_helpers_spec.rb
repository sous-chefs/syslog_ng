#
# Cookbook:: syslog_ng
# Spec:: rewrite_helpers_spec
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

describe 'SyslogNg::RewriteHelpers' do
  let(:dummy_class) { Class.new { include SyslogNg::RewriteHelpers } }

  describe '.rewrite_builder' do
    context('given subst rewrite') do
      param = {
        'function' => 'subst',
        'match' => 'IP',
        'replacement' => 'IP-Address',
        'value' => 'MESSAGE',
        'flags' => nil,
        'condition' => nil,
        'additional_options' => {},
      }

      it 'returns valid config string' do
        expect(dummy_class.new.rewrite_builder(param)).to be_a(String)
        expect(dummy_class.new.rewrite_builder(param)).to eql('subst("IP", "IP-Address", value("MESSAGE"))')
      end
    end

    context('given set rewrite') do
      param = {
        'function' => 'set',
        'match' => 'myhost',
        'value' => 'HOST',
      }

      it 'returns valid config string' do
        expect(dummy_class.new.rewrite_builder(param)).to be_a(String)
        expect(dummy_class.new.rewrite_builder(param)).to eql('set("myhost", value("HOST"))')
      end
    end

    context('given set rewrite with condition') do
      param = {
        'function' => 'set',
        'match' => 'myhost',
        'value' => 'HOST',
        'condition' => 'program("myapplication")',
      }

      it 'returns valid config string' do
        expect(dummy_class.new.rewrite_builder(param)).to be_a(String)
        expect(dummy_class.new.rewrite_builder(param)).to eql('set("myhost", value("HOST") condition(program("myapplication")))')
      end
    end

    context('given unset rewrite') do
      param = {
        'function' => 'unset',
        'value' => 'HOST',
      }

      it 'returns valid config string' do
        expect(dummy_class.new.rewrite_builder(param)).to be_a(String)
        expect(dummy_class.new.rewrite_builder(param)).to eql('unset(value("HOST"))')
      end
    end

    context('given groupunset rewrite') do
      param = {
        'function' => 'groupunset',
        'values' => '.SDATA.*',
      }

      it 'returns valid config string' do
        expect(dummy_class.new.rewrite_builder(param)).to be_a(String)
        expect(dummy_class.new.rewrite_builder(param)).to eql('groupunset(values(".SDATA.*"))')
      end
    end

    context('given groupset rewrite') do
      param = {
        'function' => 'groupset',
        'match' => 'myhost',
        'values' => %w(HOST FULLHOST),
      }

      it 'returns valid config string' do
        expect(dummy_class.new.rewrite_builder(param)).to be_a(String)
        expect(dummy_class.new.rewrite_builder(param)).to eql('groupset("myhost", values("HOST", "FULLHOST"))')
      end
    end

    context('given set-tag rewrite') do
      param = {
        'function' => 'set-tag',
        'tags' => %w(test-tag-01 test-tag-02),
      }

      it 'returns valid config string' do
        expect(dummy_class.new.rewrite_builder(param)).to be_a(String)
        expect(dummy_class.new.rewrite_builder(param)).to eql('set-tag("test-tag-01", "test-tag-02")')
      end
    end

    context('given clear-tag rewrite') do
      param = {
        'function' => 'clear-tag',
        'tags' => [
          'test-tag-01',
        ],
      }

      it 'returns valid config string' do
        expect(dummy_class.new.rewrite_builder(param)).to be_a(String)
        expect(dummy_class.new.rewrite_builder(param)).to eql('clear-tag("test-tag-01")')
      end
    end

    context('given credit-card-mask rewrite') do
      param = {
        'function' => 'credit-card-mask',
        'value' => 'cc_field',
      }

      it 'returns valid config string' do
        expect(dummy_class.new.rewrite_builder(param)).to be_a(String)
        expect(dummy_class.new.rewrite_builder(param)).to eql('credit-card-mask(value("cc_field"))')
      end
    end
  end
end
