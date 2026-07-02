# frozen_string_literal: true

name 'syslog_ng'

run_list 'syslog_ng_test::selinux',
         'syslog_ng_test::package',
         'syslog_ng_test::service',
         'syslog_ng_test::config'

named_run_list :default,
               'syslog_ng_test::selinux',
               'syslog_ng_test::package',
               'syslog_ng_test::service',
               'syslog_ng_test::config'

named_run_list :config,
               'syslog_ng_test::selinux',
               'syslog_ng_test::package_copr',
               'syslog_ng_test::service',
               'syslog_ng_test::config',
               'syslog_ng_test::block',
               'syslog_ng_test::destination',
               'syslog_ng_test::source',
               'syslog_ng_test::filter',
               'syslog_ng_test::log',
               'syslog_ng_test::template',
               'syslog_ng_test::parser',
               'syslog_ng_test::rewrite'

cookbook 'syslog_ng', path: '.'
cookbook 'yum-epel', git: 'https://github.com/sous-chefs/yum-epel.git', branch: 'main'
cookbook 'syslog_ng_test', path: 'test/cookbooks/syslog_ng_test'
