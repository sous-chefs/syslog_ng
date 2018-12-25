#
# Cookbook:: syslog-ng
# Attribute:: config
#
# Copyright:: 2018, Ben Hughes
#

default['syslog-ng']['options'] = {
  'flush_lines': 0,
  'time_reopen': 10,
  'log_fifo_size': 1000,
  'chain_hostnames': 'off',
  'use_dns': 'no',
  'use_fqdn': 'no',
  'create_dirs': 'no',
  'keep_hostname': 'yes',
}

default['syslog-ng']['console_logging'] = false

default['syslog-ng']['combined'] = {}
default['syslog-ng']['destination'] = {}
default['syslog-ng']['filter'] = {}
default['syslog-ng']['log'] = {}

# default['syslog-ng']['source'] = {}
default['syslog-ng']['source']['s_sys'] = {
  'system': {},
  'internal': {},
  'udp': {
    'ip': '0.0.0.0',
    'port': 514,
  },
}
