# Inspec test for recipe syslog_ng_test::log

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('syslog-ng') do
  it { should be_running }
end

%w(l_test l_test_2 l_test_embedded l_test_embedded).each do |file|
  describe file("/etc/syslog-ng/log.d/#{file}.conf") do
    it { should exist }
    it { should be_file }
    it { should_not be_directory }
  end
end

describe file('/etc/syslog-ng/log.d/l_test_embedded.conf') do
  its('content') { should match /tcp\(ip\(127.0.0.1\) port\(5516\)\)/ }
  its('content') { should match %r{file\("/var/log/embedded_test/test_file_1.log" flush_lines\(10\) create-dirs\(yes\)\);} }
  its('content') { should match /\(\(facility\(mail\)\) and \(facility\(cron\) or facility\(authpriv\)\)\)/ }
end

describe file('/etc/syslog-ng/log.d/l_test_junction.conf') do
  its('content') { should match /tcp\(ip\(127.0.0.1\) port\(5520\) flags\("no-parse"\)\)/ }
  its('content') { should match %r{file\("/var/log/junction_test/test_file_junction.log" flush_lines\(10\) create-dirs\(yes\)\);} }
  its('content') { should match /junction {|channel {/ }
end
