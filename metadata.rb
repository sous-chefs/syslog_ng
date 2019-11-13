name 'syslog_ng'
maintainer 'Ben Hughes'
maintainer_email 'bmhughes@bmhughes.co.uk'
license 'Apache-2.0'
description 'Installs/Configures syslog_ng'
long_description 'Installs/Configures syslog_ng'
version '0.3.3'
chef_version '>= 12.14'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/bmhughes/syslog_ng/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/bmhughes/syslog_ng'

os_support = {
  'redhat' => '>= 7.0.0',
  'centos' => '>= 7.0.0',
  'fedora' => '>= 28.0',
  'debian' => '>= 8.0.0',
  'ubuntu' => '>= 16.04',
  'amazon' => '>= 2.0.0',
}

os_support.each do |os, ver|
  supports os, ver
end

depends 'yum-epel'
