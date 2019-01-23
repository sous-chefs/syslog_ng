# syslog_ng

 ![Release](https://img.shields.io/github/release/bmhughes/syslog_ng.svg) [![Build Status](https://travis-ci.org/bmhughes/syslog_ng.svg?branch=master)](https://travis-ci.org/bmhughes/syslog_ng) ![License](https://img.shields.io/github/license/bmhughes/syslog_ng.svg)

Provides a set of resources to install and configure syslog-ng.

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

Used to generate the global configuration file, can be used extend to the global config file if you do not wish to separate elements into their own file.

- `node['syslog_ng']['config']['config_dir']` - Configuration root directory
- `node['syslog_ng']['config']['config_file']` - Global configuration filename
- `node['syslog_ng']['config']['config_template_cookbook']` - Cookbook to source the global configuration template file
- `node['syslog_ng']['config']['config_template_template']` - Template file to use for generating the global configuration file
- `node['syslog_ng']['config']['config_dirs']` - Configuration directories to create and include in the global config file
- `node['syslog_ng']['config']['options']` - A hash containing global options
- `node['syslog_ng']['config']['console_logging']` - When set `true` the global log to console `log` entry will be created

- `node['syslog_ng']['config']['source']` - A hash containing the global `source`(s) configuration
- `node['syslog_ng']['config']['destination']` - A hash containing the global `destination`(s) configuration
- `node['syslog_ng']['config']['filter']` - A hash containing the global `filter`(s) configuration
- `node['syslog_ng']['config']['log']` - A hash containing the global `log`(s) configuration

- `node['syslog_ng']['config']['preinclude']` - An array of files to include at the beginning of the global configuration file before any other directives
- `node['syslog_ng']['config']['include']` - An array of files to include in the global configuration file

- `node['syslog_ng']['config']['combined']` - A hash containing the global combined configuration directives, that is `log` entries which contain all their directives rather than referencing other `source`/`filter`/`destination` directives

### syslog_ng::install

- `node['syslog_ng']['install']['remove_rsyslog']` - When set `true` rsyslog will be explicitly removed, otherwise it will be disabled
- `node['syslog_ng']['install']['copr_repo_version']` - Version to install from COPR as a float, set to current latest version which is `3.19`. See [czanik COPR](https://copr.fedorainfracloud.org/coprs/czanik/) for versions available to install.

## Resources

### config_global

Generates the `syslog-ng.conf` file from node attributes containing the global configuration.

See [usage](#config_global-usage) for examples.

#### Actions

- `create` - Create the syslog-ng global configuration file
- `disable` - Remove the syslog-ng global configuration file

#### Properties

All properties are optional as by default they will be sourced from node attributes, see the attribute file [config.rb](/attributes/config.rb) for hash format.

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

See [usage](#destination-usage) for examples.

#### Actions

- `create` - Create a syslog-ng destination configuration file
- `disable` - Remove a syslog-ng destination configuration file

#### Properties

| Property      | Optional? | Type   | Description                                                                  |
|---------------|-----------|--------|------------------------------------------------------------------------------|
| `config_dir`  | Yes       | String | Directory to create config file, defaults to `/etc/syslog-ng/destination.d`  |
| `cookbook`    | Yes       | String | Override cookbook to source the template file from                           |
| `source`      | Yes       | String | Override the template source file                                            |
| `driver`      | No        | String | The destination driver to use                                                |
| `path`        | Yes       | String | The path for the destination driver (if it supports being specified one)     |
| `parameters`  | Yes       | Hash   | Driver parameters and options                                                |

### filter

See [usage](#filter-usage) for examples.

#### Actions

- `create` - Create a syslog-ng filter configuration file
- `disable` - Remove a syslog-ng filter configuration file

#### Properties

| Property      | Optional? | Type   | Description                                                                  |
|---------------|-----------|--------|------------------------------------------------------------------------------|
| `config_dir`  | Yes       | String | Directory to create config file, defaults to `/etc/syslog-ng/filter.d`       |
| `cookbook`    | Yes       | String | Override cookbook to source the template file from                           |
| `source`      | Yes       | String | Override the template source file                                            |
| `parmameters` | No        | String | A syslog-ng filter directive modelled as a Hash                              |

### install

See [usage](#install-usage) for examples.

#### Actions

- `install` - Install syslog-ng
- `remove` - Uninstall syslog-ng

#### Properties

| Property         | Optional? | Type   | Description                                                              |
|------------------|-----------|--------|--------------------------------------------------------------------------|
| `package_source` | No        | String | Package source selection choices are `package_distro` or `package_copr`  |
| `remove_rsyslog` | No        | String | Remove rsyslog package during installation, otherwise disable the service.|

### log

See [usage](#log-usage) for examples.

#### Actions

- `create` - Create a syslog-ng log configuration file
- `disable` - Remove a syslog-ng log configuration file

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

See [usage](#source-usage) for examples.

#### Actions

- `create` - Create a syslog-ng source configuration file
- `disable` - Remove a syslog-ng source configuration file

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

Returns the current installed version as a float to be used for the version directive in the global configuration file.

#### `SyslogNg::InstallHelpers.repo_get_packages`

Returns an array of the packages to install from the relevant package manager.

#### `SyslogNg::InstallHelpers.installed_get_packages`

Returns an array of install syslog-ng packages to remove as part of an uninstall.

## Usage

This cookbook contains no recipes and only provides resources to be directly used or wrapped in a wrapper cookbook.

### Resources

#### config_global Usage

[Resource](#config_global)

All properties are optional and by default the settings in the generated global configuration will be retrieved from node attributes, any properties can be overridden by changing the attributes, specifying a different attribute or providing a value to the relevant resource property.

The default node attributes for the global configuration generate a Redhat-style default syslog setup.

##### Example 1 - Using node attributes

```ruby
syslog_ng_config_global '/etc/syslog-ng/syslog-ng.conf' do
  action :create
end
```

#### destination Usage

[Resource](#destination)

Generates a syslog-ng [destination](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.19/administration-guide/29#TOPIC-1094570) configuration statement.

Some destination drivers accept a non-named parameter which is generally a path (the file and pipe driver accept a path) so an additional path property is provided alongside the parameters.

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

#### filter Usage

[Resource](#filter)

Generates a syslog-ng [filter](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.19/administration-guide/54#TOPIC-1094669) configuration statement.

Due to the large amount of possible combinations of Boolean operators and containers to which can be applied in a filter, this resource has a reasonably complex Hash structure and despite trying to break this as much as possible in testing, this library will very likely have some bugs in it.

In the case of the library being unable to generate a filter there is the option of giving the correctly formatted filter as a String or as an Array of String, in this case it is up to the implementer to ensure that it is a correctly formatted filter statement for syslog-ng.

##### Example 1 - Contained OR'd common filters

Hash:

```ruby
syslog_ng_filter 'f_test' do
  parameters(
    'container' => {
      'operator' => 'or',
      'facility' => %w(mail authpriv cron),
    }
  )
  action :create
end
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
syslog_ng_filter 'f_test_contained' do
  parameters(
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
  )
  action :create
end
```

Generates:

```c
filter f_test_contained {
  ((facility(mail)) and (facility(cron) or facility(authpriv)));
};
```

##### Example 3 - Multiple of the same filter given as an Array

- syslog-ng implicitly takes multiple filters within a contained group **without** a Boolean operator as being `and`'d so the library explicitly specifies it if no other operator has been given.

```ruby
syslog_ng_filter 'f_test_array_and' do
  parameters(
    'container' => {
      'facility' => %w(mail authpriv cron),
    }
  )
  action :create
end
```

Generates:

```c
filter f_test_array {
  (facility(mail) and facility(authpriv) and facility(cron));
};
```

- The same with an `or` operator specified

```ruby
syslog_ng_filter 'f_test_array_or' do
  parameters(
    'container' => {
      'operator' => 'or',
      'facility' => %w(mail authpriv cron),
    }
  )
  action :create
end
```

Generates:

```c
filter f_test_array_or {
  (facility(mail) or facility(authpriv) or facility(cron));
};
```

##### Example 4 - Pass a raw filter String or Array

```ruby
syslog_ng_filter 'f_test_raw_string' do
  parameters 'host("example") and match("deny" value("MESSAGE"))'
  action :create
end
```

Generates:

```c
filter f_test_raw_string {
    host("example") and match("deny" value("MESSAGE"));
};
```

- An Array

```ruby
syslog_ng_filter 'f_test_raw_string_array' do
  parameters ['host("example1")', 'or host("example2")', 'or (host("example3") and not match("test" value("NOT_ME_MESSAGE")))']
  action :create
end
```

Generates:

```c
filter f_test_raw_string_array {
    host("example1") or host("example2") or (host("example3") and not match("test" value("NOT_ME_MESSAGE")));
};
```

#### install Usage

There are two installation methods available `package_distro` and `package_copr`. The COPR installation method is only available to current Redhat and Fedora (7+ and 28+) distributions but does provide up-to-date versions that aren't in the distribution repositories.

By default the resource will remove rsyslog which is the default syslog daemon on the supported distros, if this is set to `false` then the rsyslog service will just be disabled instead. Some package managers will remove rsyslog anyway when installing syslog-ng so even if this set to `false` rsyslog can still be removed.

The `syslog_ng_install` resource does not require a name property.

##### Distribution repository package installation

```ruby
syslog_ng_install '' do
  action :install
end
```

##### COPR repository package installation

```ruby
syslog_ng_install '' do
  package_source 'package_copr'
  action :install
end
```

##### Uninstall

```ruby
syslog_ng_install '' do
  action :remove
end
```

#### log Usage

Generates a syslog-ng [source](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.19/administration-guide/50#TOPIC-1094654) configuration statement.

A log statement is the last part of a combination of `source`, `filter` and `destination` resources to create a completed log configuration with syslog-ng. Multiple source, filter and destination elements can be passed to the resource as a String Array.

*The resource does not presently support embedded log statements, this will be added as a future development.*

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

#### source Usage

Generates a syslog-ng [source](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.19/administration-guide/16#TOPIC-1094519) configuration statement.

##### Example 1 - TCP source

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

##### Example 2 - Wildcard source

```ruby
syslog_ng_source 's_test_wildcard_file' do
  driver 'wildcard-file'
  parameters(
    'base-dir' => '/var/log',
    'filename-pattern' => '*.log',
    'recursive' => 'no',
    'follow-freq' => 1
  )
  description 'Follow all files in the /var/log directory'
  action :create
end

```
Generates:

```c
# Source - Follow all files in the /var/log directory
source s_test_wildcard_file {
    wildcard-file(base-dir("/var/log") filename-pattern("*.log") recursive(no) follow-freq(1));
};
```

## Authors

- Ben Hughes (<https://github.com/bmhughes>)

## License

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
