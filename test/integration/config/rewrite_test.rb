# Inspec test for recipe syslog_ng_test::filter

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('syslog-ng') do
  it { should be_running }
end

%w(
  r_test_ip
  r_test_set
  r_test_set_additional
  r_test_unset
  r_test_groupunset
  r_test_groupset_single
  r_test_groupset_array
  r_test_set_condition
  r_test_set_tag
  r_test_clear_tag
  r_test_credit_card_mask
  r_test_multiple).each do |file|
  describe file("/etc/syslog-ng/rewrite.d/#{file}.conf") do
    it { should exist }
    its('type') { should cmp 'file' }
    it { should be_file }
    it { should_not be_directory }
  end
end
