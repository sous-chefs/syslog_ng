#
# Cookbook:: syslog_ng
# Attribute:: install
#
# Copyright:: 2018, Ben Hughes
#

default['syslog_ng']['install']['remove_rsyslog'] = true
default['syslog_ng']['install']['method'] = 'package_distro'
default['syslog_ng']['install']['rhel']['method'] = 'package_distro'
default['syslog_ng']['install']['rhel']['copr_repo_version'] = '3.19'

default['syslog_ng']['install']['rhel']['package_distro_base'] = [
  'syslog-ng',
  'syslog-ng-devel',
]
default['syslog_ng']['install']['rhel']['package_copr_modules'] = [
  'syslog-ng-geoip',
  'syslog-ng-http',
  'syslog-ng-java',
  'syslog-ng-libdbi',
  'syslog-ng-redis',
  'syslog-ng-riemann',
  'syslog-ng-smtp',
]
default['syslog_ng']['install']['rhel']['package_distro_modules'] = [
  'syslog-ng-geoip',
  'syslog-ng-libdbi',
  'syslog-ng-mongodb',
  'syslog-ng-redis',
  'syslog-ng-smtp',
]
default['syslog_ng']['install']['debian']['package_distro_base'] = [
  'syslog-ng',
  'syslog-ng-core',
  'syslog-ng-dev',
]
default['syslog_ng']['install']['debian']['package_distro_modules'] = [
  'syslog-ng-mod-add-contextual-data',
  'syslog-ng-mod-amqp',
  'syslog-ng-mod-basicfuncs-plus',
  'syslog-ng-mod-extra',
  'syslog-ng-mod-geoip',
  'syslog-ng-mod-getent',
  'syslog-ng-mod-graphite',
  'syslog-ng-mod-grok',
  'syslog-ng-mod-journal',
  'syslog-ng-mod-json',
  'syslog-ng-mod-kafka',
  'syslog-ng-mod-lua',
  'syslog-ng-mod-map-value-pairs',
  'syslog-ng-mod-mongodb',
  'syslog-ng-mod-perl',
  'syslog-ng-mod-python',
  'syslog-ng-mod-redis',
  'syslog-ng-mod-riemann',
  'syslog-ng-mod-rss',
  'syslog-ng-mod-smtp',
  'syslog-ng-mod-snmptrapd-parser',
  'syslog-ng-mod-sql',
  'syslog-ng-mod-stardate',
  'syslog-ng-mod-stomp',
  'syslog-ng-mod-tag-parser',
  'syslog-ng-mod-trigger',
  'syslog-ng-mod-xml-parser',
  'syslog-ng-mod-zmq',
]
