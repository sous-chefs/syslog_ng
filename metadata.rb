name 'syslog-ng'
maintainer 'Ben Hughes'
maintainer_email 'bmhughes@bmhughes.co.uk'
license 'Apache-2.0'
description 'Installs/Configures Syslog-NG'
long_description 'Installs/Configures Syslog-NG'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/bmhughes/syslog-ng/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/bmhughes/syslog-ng'

os_support = {
  'redhat' => '>= 7.0.0',
  'centos' => '>= 7.0.0',
  'fedora' => '>= 28.0',
}

os_support.each do |os, ver|
  supports os, ver
end

depends 'yum-epel'
