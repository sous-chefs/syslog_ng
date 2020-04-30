#
# Cookbook:: syslog_ng
# Spec:: template_spec
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

describe 'syslog_ng_template' do
  step_into :syslog_ng_template
  platform 'centos'

  context 'create syslog-ng template config file' do
    recipe do
      syslog_ng_template 't_first_template' do
        template_expression 'sample-text'
        action :create
      end
    end

    it 'Creates the template config file correctly' do
      is_expected.to render_file('/etc/syslog-ng/template.d/t_first_template.conf')
        .with_content(/# Template - t_first_template/)
        .with_content(/template t_first_template {/)
        .with_content(/template\("sample-text"\); template-escape\(no\);/)
    end
  end
end
