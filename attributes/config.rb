#
# Cookbook:: syslog_ng
# Attribute:: config
#
# Copyright:: 2018, Ben Hughes
#

default['syslog_ng']['options'] = {
  'flush_lines': 0,
  'time_reopen': 10,
  'log_fifo_size': 1000,
  'chain_hostnames': 'off',
  'use_dns': 'no',
  'use_fqdn': 'no',
  'create_dirs': 'no',
  'keep_hostname': 'yes',
}

default['syslog_ng']['console_logging'] = false

default['syslog_ng']['combined'] = {}
default['syslog_ng']['destination'] = {}
default['syslog_ng']['filter'] = {}
default['syslog_ng']['log'] = {}

# default['syslog_ng']['source'] = {}
default['syslog_ng']['source']['s_sys'] = {
  'system': {},
  'internal': {},
  'udp': {
    'ip': '0.0.0.0',
    'port': 514,
  },
}
