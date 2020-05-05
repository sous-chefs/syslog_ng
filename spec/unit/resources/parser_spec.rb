#
# Cookbook:: syslog_ng
# Spec:: parser_spec
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

describe 'syslog_ng_parser' do
  step_into :syslog_ng_parser
  platform 'centos'

  context 'create syslog-ng parser config file' do
    recipe do
      syslog_ng_parser 'p_csv_parser' do
        parser 'csv-parser'
        options 'columns' => '"HOSTNAME.NAME", "HOSTNAME.ID"', 'delimiters' => '"-"', 'flags' => 'escape-none', 'template' => '"${HOST}"'
        action :create
      end
    end

    it 'Creates the parser config file correctly' do
      is_expected.to render_file('/etc/syslog-ng/parser.d/p_csv_parser.conf')
        .with_content(/# Parser - p_csv_parser/)
        .with_content(/parser p_csv_parser {/)
        .with_content(/columns\("HOSTNAME.NAME", "HOSTNAME.ID"\)/)
        .with_content(/template\("\$\{HOST\}"\)/)
    end
  end
end
