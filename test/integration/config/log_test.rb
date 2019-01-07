# # encoding: utf-8

# Inspec test for recipe syslog_ng::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/etc/syslog-ng/logs.d/l_test.conf') do
  it { should exist }
  its('type') { should cmp 'file' }
  it { should be_file }
  it { should_not be_directory }
end

describe service('syslog-ng') do
  it { should be_running }
end
