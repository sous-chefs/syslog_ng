# syslog_ng_config

[Back to resource list](../README.md#resources)

Generates the `syslog-ng.conf` file containing the global configuration.

## Actions

- `:create` - Create the syslog-ng global configuration file
- `:delete` - Remove the syslog-ng global configuration file

## Properties

| Name                   | Type          | Default                          | Description                                                         | Allowed Values      |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- | ------------------- |
| `config_file`          | String        | `/etc/syslog-ng/syslog-ng.conf`  | The path to the Syslog-NG server configuration on disk              |                     |
| `config_version`       | String, Float | Installed version                | The configuration file software version                             |                     |
| `cookbook`             | String        | `syslog-ng`                      | Cookbook to source configuration file template from                 |                     |
| `template`             | String        | `syslog-ng/syslog-ng.conf.erb`   | Template to use to generate the configuration file                  |                     |
| `owner`                | String        | `root`                           | Owner of the generated configuration file                           |                     |
| `group`                | String        | `root`                           | Group of the generated configuration file                           |                     |
| `mode`                 | String        | `0640`                           | Filemode of the generated configuration file                        |                     |
| `options`              | Hash          | Default global syslog options    | Syslog-NG server global options                                     |                     |
| `source`               | Hash          | Default global syslog sources    | Syslog-NG server global log sources                                 |                     |
| `destination`          | Hash          | Default global syslog destinations| Syslog-NG server global log destinations                           |                     |
| `filter`               | Hash          | Default global syslog filters    | Syslog-NG server global log filters                                 |                     |
| `log`                  | Hash          | Default global syslog logs       | Syslog-NG server global logs                                        |                     |
| `preinclude`           | Array         |                                  | Files to include at the beginning of the global configuration file  |                     |
| `include`              | Array         |                                  | Files to include in the global configuration file                   |                     |

## Usage

All properties are optional and by default the settings in the generated global configuration will be retrieved from node attributes, any properties can be overridden by changing the attributes, specifying a different attribute or providing a value to the relevant resource property.

The default node attributes for the global configuration generate a Redhat-style default syslog setup.

### Example

```ruby
syslog_ng_config_global '/etc/syslog-ng/syslog-ng.conf' do
  action :create
end
```
