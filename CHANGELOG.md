# CHANGELOG

## Unreleased

- resolved cookstyle error: resources/install.rb:58:28 refactor: `ChefStyle/UsePlatformHelpers`
- resolved cookstyle error: resources/install.rb:93:26 refactor: `ChefStyle/UsePlatformHelpers`

## v0.3.4 (2020-01-14)

- Update default COPR versions to 3.25
- Foodcritic fixes
- Update Kitchen platforms

## v0.3.3 (2019-11-16)

- #25 - Fix Debian/Ubuntu latest package repository

## v0.3.2 (2019-08-20)

- Add the ability to specify unquoted parameter string values as symbols.

## v0.3.1 (2019-07-09)

- Add package exclude option to install resource
- Add `githead` installation option

## v0.3.0 (2019-07-04)

- Default COPR repository updated to v3.22
- Add log junction/channel support

## v0.2.1 (2019-04-29)

- Add missing rewrite property to log resource
- Add multi function support to rewrite resource

## v0.2.0 (2019-04-26)

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

## v0.1.0 (2019-02-08)

## Initial release

- Installs syslog-ng from distro packages or COPR on CentOS/Fedora.
- Generates global configuration file from node attributes.
- Generates from node attributes:
  - Destinations
  - Filters
  - Sources
  - Logs
