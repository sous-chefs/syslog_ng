# syslog_ng CHANGELOG

This file is used to list changes made in each version of the syslog_ng cookbook.

## 0.3.0 (2019-07-03)

- Default COPR repository updated to v3.22
- Add log junction/channel support

## 0.2.1 (2019-04-29)

- Add missing rewrite property to log resource
- Add multi function support to rewrite resource

## 0.2.0 (2019-04-26)

- Default COPR repository updated to v3.20
- Added resources to create:
  - Template
  - Rewrite
  - Parser
- Added multiline generation for source and destinations
- Added multiple driver support for source and destinations
- Added embedded source/destination/filter statement support to the log resource
- Added latest version repo support for deb based distributions
- The `copr` install resource option has changed to `latest` to reflect addition of apt support
- Added `cleanup` option to the install resource to remove superseded COPR `.repo` files on update
- Helper libraries refactored
- Various bug fixes

## 0.1.0 (2019-02-08)

### Initial release

- Installs syslog-ng from distro packages or COPR on CentOS/Fedora.
- Generates global configuration file from node attributes.
- Generates from node attributes:
  - Destinations
  - Filters
  - Sources
  - Logs
