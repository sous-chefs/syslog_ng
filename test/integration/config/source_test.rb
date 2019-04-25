# # encoding: utf-8

# Inspec test for recipe syslog_ng_test::source

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('syslog-ng') do
  it { should be_running }
end

%w(s_test_tcp s_test_pipe).each do |file|
  describe file("/etc/syslog-ng/source.d/#{file}.conf") do
    it { should exist }
    its('type') { should cmp 'file' }
    it { should be_file }
    it { should_not be_directory }
  end
end

describe file('/etc/syslog-ng/source.d/s_test_tcpudp.conf') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }
  its('type') { should cmp 'file' }
  its('content') { should match /tcp\(ip\(127.0.0.1\) port\("5514"\)\)/ }
  its('content') { should match /udp\(ip\(127.0.0.1\) port\("5514"\)\)/ }
end

describe file('/etc/syslog-ng/source.d/s_test_network_multiline.conf') do
  it { should exist }
  it { should be_file }
  it { should_not be_directory }
  its('type') { should cmp 'file' }
  # its('content') { should match /transport("tcp")/ }
end
