#
# Cookbook:: syslog-ng
# Attribute:: install
#
# Copyright:: 2018, Ben Hughes
#

default['syslog-ng']['install']['remove_rsyslog'] = true
default['syslog-ng']['install']['method'] = 'repo_distro'
default['syslog-ng']['install']['copr_repo_version'] = '3.19'
default['syslog-ng']['install']['copr_repo_packages'] = [
  'syslog-ng',
  'syslog-ng-devel',
  'syslog-ng-geoip',
  'syslog-ng-http',
  'syslog-ng-java',
  'syslog-ng-libdbi',
  'syslog-ng-mongodb',
  'syslog-ng-redis',
  'syslog-ng-riemann',
  'syslog-ng-smtp',
]
default['syslog-ng']['install']['distro_repo_packages'] = [
  'syslog-ng',
  'syslog-ng-devel',
  'syslog-ng-geoip',
  'syslog-ng-libdbi',
  'syslog-ng-mongodb',
  'syslog-ng-redis',
  'syslog-ng-smtp',
]