#
# Cookbook:: syslog_ng
# Library:: rewrite
#
# Copyright:: 2018, Ben Hughes <bmhughes@bmhughes.co.uk>, All Rights Reserved.
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

require_relative '_common'

module SyslogNg
  module RewriteHelpers
    include SyslogNg::CommonHelpers
    def rewrite_builder(parameters)
      raise ArgumentError, "config_rewrite_map: Expected syslog-ng rewrite configuration attribute block to be a Hash, got a #{parameters.class}." unless parameters.is_a?(Hash)
      raise ArgumentError, "config_rewrite_map: Invalid rewrite operator specified, got #{parameters['function']} which is not a valid syslog-ng rewrite operation." unless SYSLOG_NG_REWRITE_OPERATORS.include?(parameters['function'])

      int_parameters = parameters.dup
      config_string = ''
      config_string.concat(int_parameters.delete('function') + '(')
      config_string.concat(build_parameter_string(parameters: int_parameters, unnamed_parameters: SYSLOG_NG_REWRITE_PARAMETERS_UNNAMED))

      config_string.rstrip!
      config_string = config_string[0...-1] if config_string.end_with?(',')
      config_string.concat(')')

      config_string
    end
  end
end
