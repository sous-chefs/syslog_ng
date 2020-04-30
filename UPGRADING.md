# Upgrading

This document will give you help on upgrading major versions of syslog_ng

## 1.0.0

### Removed

- Resource `syslog_ng_install`
  - Replaced by `syslog_ng_package`
  - The following functionality has been removed and will be required to be implemented by the integrator wrapper cookbook:
    - Remove installation from COPR/Latest repositories
    - Remove repoistory cleanup function
    - Remove rsyslog removal function

### Added

- Resource `syslog_ng_package` - [Documentation](./documentation/syslog_ng_package.md)

### Changed

- Resource `syslog_ng_config`  - [Documentation](./documentation/syslog_ng_config.md)
  - Renamed `syslog_ng_config_global` to `syslog_ng_config`

- Resource `syslog_ng_template` - [Documentation](./documentation/syslog_ng_template.md)
  - The `template` property has been renamed to `template_expression` to avoid a clash with the Chef template file override property

- Resource `syslog_ng_parser` - [Documentation](./documentation/syslog_ng_parser.md)
  - The `parser_options` property has been renamed to `options`
