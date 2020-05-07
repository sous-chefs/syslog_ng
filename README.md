# syslog_ng

[![Cookbook Version](https://img.shields.io/cookbook/v/syslog_ng.svg?style=flat)](https://supermarket.chef.io/cookbooks/syslog_ng)
[![CI State](https://github.com/sous-chefs/syslog_ng/workflows/ci/badge.svg)](https://github.com/sous-chefs/syslog_ng/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Provides a set of resources to install and configure syslog-ng.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Change Log

- See [CHANGELOG.md](/CHANGELOG.md) for version details and changes.

## Requirements

### Cookbooks

- `yum-epel` for RHEL/CentOS/Amazon

### Platforms

The following platforms are supported and tested with Test Kitchen:

- RHEL/CentOS 7+
- Ubuntu 16.04+
- Debian 8+
- Amazon Linux 2+

## Resources

The following resources are provided:

- [syslog_ng_block](documentation/syslog_ng_block.md)
- [syslog_ng_config](documentation/syslog_ng_config.md)
- [syslog_ng_destination](documentation/syslog_ng_destination.md)
- [syslog_ng_filter](documentation/syslog_ng_filter.md)
- [syslog_ng_log](documentation/syslog_ng_log.md)
- [syslog_ng_package](documentation/syslog_ng_package.md)
- [syslog_ng_parser](documentation/syslog_ng_parser.md)
- [syslog_ng_rewrite](documentation/syslog_ng_rewrite.md)
- [syslog_ng_service](documentation/syslog_ng_service.md)
- [syslog_ng_source](documentation/syslog_ng_source.md)
- [syslog_ng_template](documentation/syslog_ng_template.md)

### Resource Parameter Value - Notes

Parameter values can generally be passed as the expected format type for the parameter they configure, for example integers for number fields and strings for text parameters.
There are some exceptions to this rule such as the `use-dns()` parameter which accepts either `yes, no or persist_only`. In this case `persist_only` options is not a string but a symbol and must be passed as such else it will be quoted as per normal strings and syslog-ng will fail with a configuration error.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
