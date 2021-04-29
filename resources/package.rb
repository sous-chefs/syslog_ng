#
# Cookbook:: syslog_ng
# Resource:: package
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
# See the License for the spcific language governing prmissions and
# limitations under the License.

unified_mode true

include SyslogNg::Cookbook::PackageHelpers

property :packages, [String, Array],
          default: lazy { default_packages(repo_include: package_repository, repo_exclude: package_repository_exclude) },
          coerce: proc { |p| p.is_a?(Array) ? p : [p] }

property :packages_exclude, [String, Array],
          coerce: proc { |p| p.is_a?(Array) ? p : [p] },
          default: []

property :package_repository, [String, Array],
          coerce: proc { |p| p.is_a?(Array) ? p : [p] },
          description: 'Install packages from a specific repository/repositories'

property :package_repository_exclude, [String, Array],
          coerce: proc { |p| p.is_a?(Array) ? p : [p] },
          description: 'Repository/repositories to exclude when installing packages'

unified_mode true

action_class do
  def do_package_action(action)
    include_recipe 'yum-epel' if platform?('redhat', 'centos', 'amazon', 'scientific')

    packages = new_resource.packages.dup
    log "Found #{packages.count} packages to #{action}."
    unless new_resource.packages_exclude.nil? || new_resource.packages_exclude.empty?
      log "Excluding packages: #{new_resource.packages_exclude.join(', ')}."
      packages.delete_if { |package| new_resource.packages_exclude.include?(package) }
      log "There are #{packages.count} packages to #{action} after exclusion."
    end

    raise 'No packages found for installation!' if packages.empty?

    package 'syslog-ng' do
      package_name lazy { packages }
      action action
    end
  end
end

%i(install upgrade remove).each do |service_action|
  action(service_action) { do_package_action(action) }
end
