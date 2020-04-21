#
# Cookbook:: syslog_ng
# Spec:: filter_helpers_spec
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

describe 'SyslogNg::FilterHelpers' do
  let(:dummy_class) { Class.new { include SyslogNg::FilterHelpers } }

  describe '.filter_builder' do
    context('given basic filter') do
      param = {
        'facility' => 'kern',
      }
      it 'returns valid config string' do
        expect(dummy_class.new.filter_builder(param)).to be_a(String)
        expect(dummy_class.new.filter_builder(param)).to eql('facility(kern)')
      end
    end

    context('given complex filter') do
      param = {
        'level' => 'info..emerg',
        'and_not' => {
          'container' => {
            'operator' => 'or',
            'facility' => %w(mail authpriv cron),
          },
        },
      }

      it 'returns valid config string' do
        expect(dummy_class.new.filter_builder(param)).to be_a(String)
        expect(dummy_class.new.filter_builder(param)).to eql('level(info..emerg) and not (facility(mail) or facility(authpriv) or facility(cron))')
      end
    end

    context('given inplicit _and_ filter') do
      param = {
        'container' => {
          'facility' => %w(mail authpriv cron),
        },
      }

      it 'returns valid config string with _and_ present' do
        expect(dummy_class.new.filter_builder(param)).to be_a(String)
        expect(dummy_class.new.filter_builder(param)).to eql('(facility(mail) and facility(authpriv) and facility(cron))')
      end
    end

    context('given contained string') do
      param = {
        'container' => {
          'facility' => 'mail',
        },
      }

      it 'returns valid config string with _and_ present' do
        expect(dummy_class.new.filter_builder(param)).to be_a(String)
        expect(dummy_class.new.filter_builder(param)).to eql('(facility(mail))')
      end
    end

    context('given multiple contained strings') do
      param = {
        'container_outside' => {
          'operator' => 'and',
          'container_1' => {
            'facility' => 'mail',
          },
          'container_2' => {
            'facility' => 'cron',
          },
        },
      }

      it 'returns valid config string with _and_ present' do
        expect(dummy_class.new.filter_builder(param)).to be_a(String)
        expect(dummy_class.new.filter_builder(param)).to eql('((facility(mail)) and (facility(cron)))')
      end
    end

    context('given contained integer') do
      param = {
        'container_outside' => {
          'operator' => 'and',
          'container_1' => {
            'port' => 514,
          },
        },
      }

      it 'raises RuntimeError' do
        expect { dummy_class.new.filter_builder(param) }.to raise_exception(RuntimeError)
      end
    end

    context('given hash array key') do
      param = {
        'facility' => %w(mail authpriv cron),
      }

      it 'returns valid config string' do
        expect(dummy_class.new.filter_builder(param)).to be_a(String)
        expect(dummy_class.new.filter_builder(param)).to eql('facility(mail) facility(authpriv) facility(cron)')
      end
    end

    context('given array') do
      param = [
        'facility(mail)',
        'facility(authpriv)',
        'facility(cron)',
      ]

      it 'returns valid config string' do
        expect(dummy_class.new.filter_builder(param)).to be_a(String)
        expect(dummy_class.new.filter_builder(param)).to eql('facility(mail) facility(authpriv) facility(cron)')
      end
    end

    context('given string') do
      param = 'level(emerg)'

      it 'returns valid config string' do
        expect(dummy_class.new.filter_builder(param)).to be_a(String)
        expect(dummy_class.new.filter_builder(param)).to eql('level(emerg)')
      end
    end

    context('invalid filter') do
      param = {
        'invalidfilter': 'bollocks',
      }

      it 'raises ArgumentError' do
        expect { dummy_class.new.filter_builder(param) }.to raise_exception(ArgumentError)
      end
    end
  end
end
