#
# Cookbook:: syslog_ng
# Resource:: parser
#
# Copyright:: 2019, Ben Hughes <bmhughes@bmhughes.co.uk>
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

property :config_dir, String, default: '/etc/syslog-ng/rewrite.d'
property :cookbook, String
property :source, String
property :function, String, required: true, equal_to: ['subst', 'set', 'unset', 'groupset', 'groupunset', 'credit-card-mask', 'set-tag', 'clear-tag']
property :match, String
property :replacement, String
property :field, String
property :value, String
property :values, [String, Array]
property :flags, [String, Array]
property :tags, String
property :condition, String
property :additional_options, Hash, default: {}
property :description, String
