#
# Cookbook:: syslog_ng
# Attribute:: install
#
# Copyright:: 2018, Ben Hughes
#

default['syslog_ng']['install']['remove_rsyslog'] = true
default['syslog_ng']['install']['method'] = 'repo_distro'
default['syslog_ng']['install']['copr_repo_version'] = '3.19'
default['syslog_ng']['install']['copr_repo_packages'] = [
  'syslog_ng',
  'syslog_ng-devel',
  'syslog_ng-geoip',
  'syslog_ng-http',
  'syslog_ng-java',
  'syslog_ng-libdbi',
  'syslog_ng-mongodb',
  'syslog_ng-redis',
  'syslog_ng-riemann',
  'syslog_ng-smtp',
]
default['syslog_ng']['install']['distro_repo_packages'] = [
  'syslog_ng',
  'syslog_ng-devel',
  'syslog_ng-geoip',
  'syslog_ng-libdbi',
  'syslog_ng-mongodb',
  'syslog_ng-redis',
  'syslog_ng-smtp',
]