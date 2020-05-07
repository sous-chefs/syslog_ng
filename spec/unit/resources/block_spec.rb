#
# Cookbook:: syslog_ng
# Spec:: block_spec
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

describe 'syslog_ng_block' do
  step_into :syslog_ng_block
  platform 'centos'

  context 'create syslog-ng block config file' do
    recipe do
      syslog_ng_block 'b_test_file_destination_block' do
        type :destination
        parameters(
          'file' => :empty
        )
        definition(
          'file' => {
            'path' => '`file`',
            'flush_lines' => 10,
            'create-dirs' => 'yes',
          }
        )
        action :create
      end
    end

    it 'Creates the parser config file correctly' do
      is_expected.to render_file('/etc/syslog-ng/block.d/b_test_file_destination_block.conf')
        .with_content(/# Block - b_test_file_destination_block/)
        .with_content(/block destination b_test_file_destination_block\(file\(\)\) {/)
        .with_content(/`file`/)
        .with_content(/create-dirs\(yes\)/)
    end
  end
end
