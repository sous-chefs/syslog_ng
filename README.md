# syslog_ng

 ![Release](https://img.shields.io/github/release/bmhughes/syslog_ng.svg) [![Build Status](https://travis-ci.org/bmhughes/syslog_ng.svg?branch=master)](https://travis-ci.org/bmhughes/syslog_ng) ![License](https://img.shields.io/github/license/bmhughes/syslog_ng.svg)

Installs and configures syslog-ng for system and user defined logs.

## Change Log

- See [CHANGELOG.md](/CHANGELOG.md) for version details and changes.

## Requirements

### Cookbooks

- `yum-epel` for RHEL/CentOS

### Platforms

The following platforms are supported and tested with Test Kitchen:

- RHEL/CentOS 7+
- Fedora 28+
- Ubuntu 16.04+
- Debian 8+
- Amazon Linux 2+

## Attributes

### syslog_ng::config

Used to generate the global configuration file, can be used extend to the global config file if you do not wish to seperate elements into their own file.

- `node['syslog_ng']['config']['config_dir']` - Configuration root directory
- `node['syslog_ng']['config']['config_file']` - Global configuration filename
- `node['syslog_ng']['config']['config_template_cookbook']` - Cookbook to source the global configuration template file
- `node['syslog_ng']['config']['config_template_template']` - Template file to use for generating the global configration file
- `node['syslog_ng']['config']['config_dirs']` - Configuration directories to create and include in the global config file
- `node['syslog_ng']['config']['options']` - A hash containing global options
- `node['syslog_ng']['config']['console_logging']` - When set `true` the global log to console `log` entry will be created

- `node['syslog_ng']['config']['source']` - A hash containing the global `source`(s) configuration
- `node['syslog_ng']['config']['destination']` - A hash containing the global `destination`(s) configuration
- `node['syslog_ng']['config']['filter']` - A hash containing the global `filter`(s) configuration
- `node['syslog_ng']['config']['log']` - A hash containing the global `log`(s) configuration

- `node['syslog_ng']['config']['preinclude']` - An array of files to include at the beginning of the global configuration file before any other directives
- `node['syslog_ng']['config']['include']` - An array of files to include in the global configuration file

- `node['syslog_ng']['config']['combined']` - A hash containing the global combinbed configuration directives, that is `log` entries which contain all their directives rather than referencing other `source`/`filter`/`destination` directives

### syslog_ng::install

- `node['syslog_ng']['install']['remove_rsyslog']` - When set `true` rsyslog will be explicitly removed, otherwise it will be disabled
- `node['syslog_ng']['install']['copr_repo_version']` - Version to install from COPR as a float, set to current latest version which is `3.19`. See [czanik COPR](https://copr.fedorainfracloud.org/coprs/czanik/) for versions available to install.

## Resources

### config_global

#### Actions

- `create` - Create the syslog-ng global configuration file
- `disable` - Remove the syslog-ng global configuration file

#### Properties

All properties are optional as by default they will be sourced from node attributes, see the attribute file `config.rb` for hash formats.

| Property      | Optional? | Type   | Description                                                                |
|---------------|-----------|--------|----------------------------------------------------------------------------|
| `cookbook`    | Yes       | String | Override cookbook to source the template file from                         |
| `source`      | Yes       | String | Override the template source file                                          |
| `options`     | Yes       | Hash   | Override the global options                                                |
| `source`      | Yes       | Hash   | Override the global sources                                                |
| `destination` | Yes       | Hash   | Override the global destinations                                           |
| `filter`      | Yes       | Hash   | Override the global filters                                                |
| `log`         | Yes       | Hash   | Override the global logs                                                   |
| `preinclude`  | Yes       | Array  | Override the global includes at the start of the global configuration file |
| `include`     | Yes       | Array  | Override the global includes                                               |

### destination

#### Actions

- `create` - Create the syslog-ng destination configuration file
- `disable` - Remove the syslog-ng destination configuration file

#### Properties

| Property      | Optional? | Type   | Description                                                                  |
|---------------|-----------|--------|------------------------------------------------------------------------------|
| `config_dir`  | Yes       | String | Directory to create config file, defaults to `/etc/syslog-ng/destination.d`  |
| `cookbook`    | Yes       | String | Override cookbook to source the template file from                           |
| `source`      | Yes       | String | Override the template source file                                            |
| `driver`      | No        | String | The destination driver to use                                                |
| `path`        | Yes       | String | The path for the destination driver if it supports being specified one       |
| `parameters`  | Yes       | Hash   | Driver parameters and options                                                |

### filter

Generates a syslog-ng [filter](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.19/administration-guide/54#TOPIC-1094669) configuration statement, due to the large amount of
possible combinations of boolean operators and containers to which they can be applied this resource has a resonable complex Hash structure. Despite trying to break this as much as possible t
his library also most likely has some bugs in it.

#### Actions

- `create` - Create the syslog-ng filter configuration file
- `disable` - Remove the syslog-ng filter configuration file

#### Properties

| Property      | Optional? | Type   | Description                                                                  |
|---------------|-----------|--------|------------------------------------------------------------------------------|
| `config_dir`  | Yes       | String | Directory to create config file, defaults to `/etc/syslog-ng/filter.d`       |
| `cookbook`    | Yes       | String | Override cookbook to source the template file from                           |
| `source`      | Yes       | String | Override the template source file                                            |
| `parmameters` | No        | String | A syslog-ng filter directive modelled as a Hash                              |

### install

#### Actions

- `install` - Install syslog-ng
- `remove` - Uninstall syslog-ng

#### Properties

| Property         | Optional? | Type   | Description                                                              |
|------------------|-----------|--------|--------------------------------------------------------------------------|
| `package_source` | No        | String | Package source selection choices are `package_distro` or `package_copr`  |
| `remove_rsyslog` | No        | String | Remove rsyslog package during instalation, otherwise disable the service.|

### log

#### Actions

- `create` - Create the syslog-ng log configuration file
- `disable` - Remove the syslog-ng log configuration file

#### Properties

| Property          | Optional? | Type          | Description                                                                  |
|-------------------|-----------|---------------|------------------------------------------------------------------------------|
| `config_dir`      | Yes       | String        | Directory to create config file, defaults to `/etc/syslog-ng/log.d`          |
| `cookbook`        | Yes       | String        | Override cookbook to source the template file from                           |
| `template_source` | Yes       | String        | Override the template source file                                            |
| `source`          | No        | String, Array | The source driver to use                                                     |
| `filter`          | Yes       | String, Array | The path for the source driver if it supports being specified one            |
| `destination`     | Yes       | String, Array | Driver parameters and options                                                |

### source

#### Actions

- `create` - Create the syslog-ng source configuration file
- `disable` - Remove the syslog-ng source configuration file

#### Properties

| Property      | Optional? | Type   | Description                                                                  |
|---------------|-----------|--------|------------------------------------------------------------------------------|
| `config_dir`  | Yes       | String | Directory to create config file, defaults to `/etc/syslog-ng/source.d`       |
| `cookbook`    | Yes       | String | Override cookbook to source the template file from                           |
| `source`      | Yes       | String | Override the template source file                                            |
| `driver`      | No        | String | The source driver to use                                                     |
| `parameters`  | Yes       | Hash   | Driver parameters and options                                                |

## Libraries

### config

Provides a set of helper methods to generate syslog-ng configuration stanzas, due to the variety and format they can be complex to construct so most of the
heavy lifting is done by the `SyslogNg::ConfigHelpers` library.

### install

#### `SyslogNg::InstallHelpers.installed_version_get`

Retrieves the current installed version as a float to be used for the version directive in the global configation file.

#### `SyslogNg::InstallHelpers.repo_get_packages`

Retrieves an array of the packages to install from the relevant package manager.

## Usage

### Resources

#### config_global

#### destination

##### Example 1

```ruby
syslog_ng_destination 'd_test' do
  driver 'file'
  path '/var/log/test.log'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
destination d_test {
    file("/var/log/test.log");
};
```

##### Example 2

```ruby
syslog_ng_destination 'd_test_params' do
  driver 'file'
  path '/var/log/test/test_params.log'
  parameters(
    'flush_lines' => 10,
    'create-dirs' => 'yes'
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
destination d_test_params {
    file("/var/log/test/test_params.log" flush_lines(10) create-dirs(yes));
};
```

#### filter

##### Example 1 - Contained OR'd common filters

Hash:

```ruby
'container' => {
  'operator' => 'or',
  'facility' => %w(mail authpriv cron),
}
```

Generates:

```c
filter f_test {
  (facility(mail) or facility(authpriv) or facility(cron));
};
```

##### Example 2 - Multiple contained groups with differing operators

Hash:

```ruby
'container_outside' => {
  'operator' => 'and',
  'container_1' => {
    'facility' => 'mail',
  },
  'container_2' => {
    'operator' => 'or',
    'facility' => %w(cron authpriv),
  },
}
```

Generates:

```c
filter f_test_contained {
  ((facility(mail)) and (facility(cron) or facility(authpriv)));
};
```

##### Example 3 - Multiple of the same filter given as an Array

- syslog-ng implicitly takes multiple filters within a contained group without a boolean operator as being `and`'d so the library explicitly specify it if no other operator has been given.

```ruby
'container' => {
  'facility' => %w(mail authpriv cron),
}
```

Generates:

```c
filter f_test_array {
  (facility(mail) and facility(authpriv) and facility(cron));
};
```

- The same with an `or` operator specified

```ruby
'container' => {
  'operator' => 'or',
  'facility' => %w(mail authpriv cron),
}
```

Generates:

```c
filter f_test_array_or {
  (facility(mail) or facility(authpriv) or facility(cron));
};
```

#### install

#### log

##### Example

```ruby
syslog_ng_log 'l_test' do
  source 's_test'
  filter 'f_test'
  destination 'd_test'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
log {
    source(s_test);
    filter(f_test);
    destination(d_test);
};
```

#### source

##### Example

```ruby
syslog_ng_source 's_test' do
  driver 'tcp'
  parameters(
    'ip' => '127.0.0.1',
    'port' => '5514'
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
source s_test {
    tcp(ip(127.0.0.1) port("5514"));
};
```
