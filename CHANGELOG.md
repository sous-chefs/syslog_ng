# CHANGELOG

## Unreleased

- Remove package exclusion logic from ruby_block - [@bmhughes](https://github.com/bmhughes)
- Package resource run in unified mode - [@bmhughes](https://github.com/bmhughes)
- Add CentOS 8 stream to kitchen testing - [@bmhughes](https://github.com/bmhughes)

## 1.1.1 - *2020-11-28*

- Remove service action from ruby_block - [@bmhughes](https://github.com/bmhughes)

## 1.1.0 - *2020-11-27*

- Add enable/disable actions to control a configuration item whilst leaving the configuration file in place - [@bmhughes](https://github.com/bmhughes)

## 1.0.2 - *2020-11-20*

- resolved cookstyle error: libraries/rewrite.rb:29:9 convention: `Style/RedundantCondition`
- resolved cookstyle error: libraries/rewrite.rb:30:11 convention: `Layout/CaseIndentation`
- resolved cookstyle error: libraries/rewrite.rb:31:13 convention: `Layout/IndentationWidth`
- resolved cookstyle error: libraries/rewrite.rb:42:11 convention: `Layout/CaseIndentation`
- resolved cookstyle error: libraries/rewrite.rb:43:13 convention: `Layout/IndentationWidth`
- resolved cookstyle error: libraries/rewrite.rb:52:11 convention: `Layout/CaseIndentation`
- resolved cookstyle error: libraries/rewrite.rb:53:13 convention: `Layout/IndentationWidth`
- resolved cookstyle error: libraries/rewrite.rb:63:11 convention: `Layout/CaseIndentation`
- resolved cookstyle error: libraries/rewrite.rb:64:13 convention: `Layout/IndentationWidth`
- resolved cookstyle error: libraries/rewrite.rb:73:11 convention: `Layout/CaseIndentation`
- resolved cookstyle error: libraries/rewrite.rb:74:13 convention: `Layout/IndentationWidth`
- resolved cookstyle error: libraries/rewrite.rb:80:11 convention: `Layout/CaseIndentation`
- resolved cookstyle error: libraries/rewrite.rb:81:13 convention: `Layout/IndentationWidth`
- resolved cookstyle error: libraries/rewrite.rb:89:11 convention: `Layout/ElseAlignment`
- resolved cookstyle error: libraries/rewrite.rb:90:13 convention: `Layout/IndentationWidth`
- resolved cookstyle error: libraries/rewrite.rb:91:11 warning: `Layout/EndAlignment`
- resolved cookstyle error: resources/block.rb:73:45 convention: `Style/RedundantCondition`
- resolved cookstyle error: resources/destination.rb:89:45 convention: `Style/RedundantCondition`
- resolved cookstyle error: resources/filter.rb:67:45 convention: `Style/RedundantCondition`
- resolved cookstyle error: resources/log.rb:90:45 convention: `Style/RedundantCondition`
- resolved cookstyle error: resources/parser.rb:71:45 convention: `Style/RedundantCondition`
- resolved cookstyle error: resources/rewrite.rb:103:45 convention: `Style/RedundantCondition`
- resolved cookstyle error: resources/source.rb:89:45 convention: `Style/RedundantCondition`
- resolved cookstyle error: test/integration/config/block_test.rb:1:1 convention: `Style/Encoding`
- resolved cookstyle error: test/integration/config/destination_test.rb:1:1 convention: `Style/Encoding`
- resolved cookstyle error: test/integration/config/filter_test.rb:1:1 convention: `Style/Encoding`
- resolved cookstyle error: test/integration/config/log_test.rb:1:1 convention: `Style/Encoding`
- resolved cookstyle error: test/integration/config/package_test.rb:1:1 convention: `Style/Encoding`
- resolved cookstyle error: test/integration/config/parser_test.rb:1:1 convention: `Style/Encoding`
- resolved cookstyle error: test/integration/config/rewrite_test.rb:1:1 convention: `Style/Encoding`
- resolved cookstyle error: test/integration/config/source_test.rb:1:1 convention: `Style/Encoding`
- resolved cookstyle error: test/integration/config/template_test.rb:1:1 convention: `Style/Encoding`
- resolved cookstyle error: test/integration/default/default_test.rb:1:1 convention: `Style/Encoding`
- Fix the pre-service action configuration test to remove compile/converge bug - [@bmhughes](https://github.com/bmhughes)
- Fix `syslog_ng_package` reporting excluded packages even when there are none - [@bmhughes](https://github.com/bmhughes)

## 1.0.1 - *2020-09-16*

- resolved cookstyle error: test/cookbooks/syslog_ng_test/recipes/package_copr.rb:22:14 refactor: `ChefCorrectness/InvalidPlatformFamilyInCase`
- Fix configuration test running every Chef run regardless of service action - [@bmhughes](https://github.com/bmhughes)

## 1.0.0 - *2020-05-14*

Version 1.0.0 has multiple breaking changes, please see [UPGRADING.md](./UPGRADING.md).

- Rename install resource to package and refactor
  - The following functionality has been removed and will be required to be implemented by the integrator wrapper cookbook:
    - Remove installation from COPR/Latest repositories
    - Remove repoistory cleanup function
    - Remove rsyslog removal function
- The `syslog_ng_template` resource `template` property has been renamed to `template_expression` to avoid a clash with the Chef template file override property
- Renamed `syslog_ng_config_global` to `syslog_ng_config`
- Multiple resource properties renamed
- Refactoring of helper modules
- Added the `syslog_ng_service` and `syslog_ng_block` resources

## 0.3.5 - *2020-05-05*

- resolved cookstyle error: resources/install.rb:58:28 refactor: `ChefStyle/UsePlatformHelpers`
- resolved cookstyle error: resources/install.rb:93:26 refactor: `ChefStyle/UsePlatformHelpers`

## v0.3.4 - *2020-01-14*

- Update default COPR versions to 3.25
- Foodcritic fixes
- Update Kitchen platforms

## v0.3.3 - *2019-11-16*

- #25 - Fix Debian/Ubuntu latest package repository

## v0.3.2 - *2019-08-20*

- Add the ability to specify unquoted parameter string values as symbols.

## v0.3.1 - *2019-07-09*

- Add package exclude option to install resource
- Add `githead` installation option

## v0.3.0 - *2019-07-04*

- Default COPR repository updated to v3.22
- Add log junction/channel support

## v0.2.1 - *2019-04-29*

- Add missing rewrite property to log resource
- Add multi function support to rewrite resource

## v0.2.0 - *2019-04-26*

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

## v0.1.0 - *2019-02-08*

- Installs syslog-ng from distro packages or COPR on CentOS/Fedora.
- Generates global configuration file from node attributes.
- Generates from node attributes:
  - Destinations
  - Filters
  - Sources
  - Logs
