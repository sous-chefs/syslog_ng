# frozen_string_literal: true

name 'syslog_ng'

run_list 'syslog_ng_test::selinux',
         'syslog_ng_test::package',
         'syslog_ng_test::service',
         'syslog_ng_test::config'

cookbook 'syslog_ng', path: '.'
cookbook 'yum-epel', git: 'https://github.com/sous-chefs/yum-epel.git', branch: 'main'
cookbook 'syslog_ng_test', path: 'test/cookbooks/syslog_ng_test'
