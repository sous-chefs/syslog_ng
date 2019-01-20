# # encoding: utf-8

# Inspec test for recipe syslog_ng::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/etc/yum.repos.d/syslog-ng319.repo') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }
  its('type') { should cmp 'file' }
  its('content') { should match /name=Copr repo for syslog-ng319 owned by czanik/ }
  its('content') { should match %r{baseurl=https:\/\/copr-be.cloud.fedoraproject.org\/results\/czanik\/syslog-ng319\/(epel|fedora)-\$releasever-\$basearch\/} }
end

describe package('syslog-ng') do
  it { should be_installed }
end

describe service('syslog-ng') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe directory('/etc/syslog-ng') do
  it { should exist }
end

describe file('/etc/syslog-ng/syslog-ng.conf') do
  it { should exist }
  its('type') { should cmp 'file' }
  it { should be_file }
  it { should_not be_directory }
end

%w(destinations.d filters.d logs.d sources.d).each do |conf_dir|
  describe directory("/etc/syslog-ng/#{conf_dir}") do
    it { should exist }
  end
end
