# # encoding: utf-8

# Inspec test for recipe syslog_ng_test::destination

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('syslog-ng') do
  it { should be_running }
end

%w(
  b_test_tcp_source_block
  b_test_file_destination_block
).each do |file|
  describe file("/etc/syslog-ng/block.d/#{file}.conf") do
    it { should exist }
    its('type') { should cmp 'file' }
    it { should be_file }
    it { should_not be_directory }
  end
end

describe file('/etc/syslog-ng/block.d/b_test_file_destination_block.conf') do
  its('content') { should match /block destination b_test_file_destination_block\(file\(\)\) {/ }
  its('content') { should match /create-dirs\(yes\)/ }
end
