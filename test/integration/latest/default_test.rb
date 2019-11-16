# # encoding: utf-8

# Inspec test for recipe syslog_ng::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

case os.family
when 'redhat', 'fedora'
  describe file('/etc/yum.repos.d/syslog-ng322.repo') do
    it { should exist }
    it { should be_file }
    it { should_not be_directory }
    its('type') { should cmp 'file' }
    its('content') { should match /name=Copr repo for syslog-ng322 owned by czanik/ }
    its('content') { should match %r{baseurl=https:\/\/copr-be.cloud.fedoraproject.org\/results\/czanik\/syslog-ng322\/(epel|fedora)-\$releasever-\$basearch\/} }
  end
when 'debian'
  describe file('/etc/apt/sources.list.d/syslog-ng-latest.list') do
    it { should exist }
    it { should be_file }
    it { should_not be_directory }
    its('type') { should cmp 'file' }
    its('content') { should match %r{deb      "http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/.*"  \./} }
  end
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

%w(destination.d filter.d log.d source.d).each do |conf_dir|
  describe directory("/etc/syslog-ng/#{conf_dir}") do
    it { should exist }
  end
end
