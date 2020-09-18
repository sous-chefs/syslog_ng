# Inspec test for recipe syslog_ng_test::destination

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('syslog-ng') do
  it { should be_running }
end

%w(d_test_file d_test_file_params d_test_mongo_params d_test_multi_file d_test_multi_file_multiline d_test_multi_file_alternative).each do |file|
  describe file("/etc/syslog-ng/destination.d/#{file}.conf") do
    it { should exist }
    its('type') { should cmp 'file' }
    it { should be_file }
    it { should_not be_directory }
  end
end

describe file('/etc/syslog-ng/destination.d/d_test_multi_file.conf') do
  its('content') { should match %r{file\("/var/log/test_file_1.log" flush_lines\(10\) create-dirs\(yes\)\);} }
  its('content') { should match %r{file\("/var/log/test_file_2.log" flush_lines\(20\) create-dirs\(yes\)\);} }
end
