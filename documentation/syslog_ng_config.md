# syslog_ng_config

[Back to resource list](../README.md#resources)

Generates the `syslog-ng.conf` file from node attributes containing the global configuration.

See [usage](#config_global-usage) for examples.

## Actions

- `create` - Create the syslog-ng global configuration file
- `delete` - Remove the syslog-ng global configuration file

## Properties

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

## Usage

All properties are optional and by default the settings in the generated global configuration will be retrieved from node attributes, any properties can be overridden by changing the attributes, specifying a different attribute or providing a value to the relevant resource property.

The default node attributes for the global configuration generate a Redhat-style default syslog setup.

### Example

```ruby
syslog_ng_config_global '/etc/syslog-ng/syslog-ng.conf' do
  action :create
end
```
