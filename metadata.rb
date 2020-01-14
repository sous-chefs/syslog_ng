name 'syslog_ng'
maintainer 'Ben Hughes'
maintainer_email 'bmhughes@bmhughes.co.uk'
license 'Apache-2.0'
description 'Installs/Configures syslog_ng'
version '0.3.4'
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

%w(redhat centos fedora debian ubuntu amazon).each { |os| supports os }

depends 'yum-epel'
