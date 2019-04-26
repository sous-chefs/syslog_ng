# # encoding: utf-8

# Inspec test for recipe syslog_ng_test::filter

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('syslog-ng') do
  it { should be_running }
end

%w(t_first_template t_second_template).each do |file|
  describe file("/etc/syslog-ng/template.d/#{file}.conf") do
    it { should exist }
    its('type') { should cmp 'file' }
    it { should be_file }
    it { should_not be_directory }
  end
end
