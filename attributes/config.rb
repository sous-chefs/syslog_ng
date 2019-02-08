#
# Cookbook:: syslog_ng
# Attribute:: config
#
# Copyright:: 2018, Ben Hughes <bmhughes@bmhughes.co.uk>
#

default['syslog_ng']['config']['config_dir'] = '/etc/syslog-ng'
default['syslog_ng']['config']['config_file'] = 'syslog-ng.conf'
default['syslog_ng']['config']['config_template_cookbook'] = 'syslog_ng'
default['syslog_ng']['config']['config_template_template'] = 'syslog-ng/syslog-ng.conf.erb'

default['syslog_ng']['config']['config_dirs'] = [
  '/etc/syslog-ng/conf.d',
  '/etc/syslog-ng/destination.d',
  '/etc/syslog-ng/filter.d',
  '/etc/syslog-ng/log.d',
  '/etc/syslog-ng/source.d',
]

# Global Options
default['syslog_ng']['config']['options'] = {
  'flush_lines': 0,
  'time_reopen': 10,
  'log_fifo_size': 1000,
  'chain_hostnames': 'off',
  'use_dns': 'no',
  'use_fqdn': 'no',
  'create_dirs': 'no',
  'keep_hostname': 'yes',
}

default['syslog_ng']['config']['console_logging'] = false

# Global Sources
default['syslog_ng']['config']['source'] = {
  's_sys': {
    'system': {},
    'internal': {},
  },
}

# Global Destinations
default['syslog_ng']['config']['destination'] = {
  'd_cons': {
    'file': {
      'path': '/dev/console',
    },
  },
  'd_mesg': {
    'file': {
      'path': '/var/log/messages',
    },
  },
  'd_auth': {
    'file': {
      'path': '/var/log/secure',
    },
  },
  'd_mail': {
    'file': {
      'path': '/var/log/maillog',
      'parameters': {
        'flush_lines': 10,
      },
    },
  },
  'd_spol': {
    'file': {
      'path': '/var/log/spooler',
    },
  },
  'd_boot': {
    'file': {
      'path': '/var/log/boot.log',
    },
  },
  'd_cron': {
    'file': {
      'path': '/var/log/cron',
    },
  },
  'd_kern': {
    'file': {
      'path': '/var/log/kern',
    },
  },
  'd_mlal': {
    'usertty': {
      'path': '*',
    },
  },
}

# Global Filters
default['syslog_ng']['config']['filter'] = {
  'f_kernel': {
    'facility': 'kern',
  },
  'f_default': {
    'level': 'info..emerg',
    'and_not': {
      'container': {
        'operator': 'or',
        'facility': %w(mail authpriv cron),
      },
    },
  },
  'f_auth': {
    'facility': 'authpriv',
  },
  'f_mail': {
    'facility': 'mail',
  },
  'f_emergency': {
    'level': 'emerg',
  },
  'f_news': {
    'facility': 'uucp',
    'or': {
      'container': {
        'operator': 'and',
        'facility': 'news',
        'level': 'crit..emerg',
      },
    },
  },
  'f_boot': {
    'facility': 'local7',
  },
  'f_cron': {
    'facility': 'cron',
  },
}

# Global Logs
default['syslog_ng']['config']['log'] = {
  'kern': {
    'source': [
      's_sys',
    ],
    'filter': [
      'f_kernel',
    ],
    'destination': [
      'd_kern',
    ],
  },
  'mesg': {
    'source': [
      's_sys',
    ],
    'filter': [
      'f_default',
    ],
    'destination': [
      'd_mesg',
    ],
  },
  'auth': {
    'source': [
      's_sys',
    ],
    'filter': [
      'f_auth',
    ],
    'destination': [
      'd_auth',
    ],
  },
  'mail': {
    'source': [
      's_sys',
    ],
    'filter': [
      'f_mail',
    ],
    'destination': [
      'd_mail',
    ],
  },
  'mlal': {
    'source': [
      's_sys',
    ],
    'filter': [
      'f_emergency',
    ],
    'destination': [
      'd_mlal',
    ],
  },
  'spol': {
    'source': [
      's_sys',
    ],
    'filter': [
      'f_news',
    ],
    'destination': [
      'd_spol',
    ],
  },
  'boot': {
    'source': [
      's_sys',
    ],
    'filter': [
      'f_boot',
    ],
    'destination': [
      'd_boot',
    ],
  },
  'cron': {
    'source': [
      's_sys',
    ],
    'filter': [
      'f_cron',
    ],
    'destination': [
      'd_cron',
    ],
  },
}

default['syslog_ng']['config']['preinclude'] = [
  'scl.conf',
]

default['syslog_ng']['config']['include'] = []

default['syslog_ng']['config']['combined'] = {}
