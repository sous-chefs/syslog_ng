# frozen_string_literal: true

source 'https://supermarket.chef.io'

metadata

cookbook 'yum-epel', '>= 3.3.0'

group :integration do
  cookbook 'syslog_ng_test', path: 'test/cookbooks/syslog_ng_test'
end
