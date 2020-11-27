# Inspec test for recipe syslog_ng_test::filter

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('syslog-ng') do
  it { should be_running }
end

%w(f_test f_test_contained f_test_array_and f_test_array_or f_test_raw_string f_test_raw_string_array).each do |file|
  describe file("/etc/syslog-ng/filter.d/#{file}.conf") do
    it { should exist }
    it { should be_file }
    it { should_not be_directory }
  end
end
