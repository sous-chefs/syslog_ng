# syslog_ng_destination

[Back to resource list](../README.md#resources)

## Actions

- `:create` - Create a syslog-ng destination configuration file
- `:delete` - Remove a syslog-ng destination configuration file
- `:enable` - Enable a pre-existing syslog-ng destination configuration file
- `:disable` - Disable a pre-existing syslog-ng destination configuration file

## Properties

| Name                   | Type          | Default                          | Description                                                         | Allowed Values      |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- | ------------------- |
| `config_dir`           | String        | /etc/syslog-ng/destionation.d    | Directory to create configuration file in                           |                     |
| `cookbook`             | String        | `syslog-ng`                      | Cookbook to source configuration file template from                 |                     |
| `template`             | String        | `syslog-ng/destination.conf.erb` | Template to use to generate the configuration file                  |                     |
| `owner`                | String        | `root`                           | Owner of the generated configuration file                           |                     |
| `group`                | String        | `root`                           | Group of the generated configuration file                           |                     |
| `mode`                 | String        | `0640`                           | Filemode of the generated configuration file                        |                     |
| `description`          | String        |                                  | Unparsed description to add to the configuration file               |                     |
| `driver`               | String, Array |                                  | Destination driver(s) to use                                        |                     |
| `path`                 | String, Array |                                  | Path(s) for the destination driver(s) (if supported)                |                     |
| `parameters`           | Hash, Array   |                                  | Driver(s) parameters and options                                    |                     |
| `configuration`        | Hash, Array   |                                  | Hash or Array of Hash containing raw driver(s) configuration        |                     |
| `multiline`            | True, False   | `false`                          | Use multiline formatting                                            |                     |

## Usage

Generates a syslog-ng [destination](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.25/administration-guide/30#TOPIC-1349402) configuration statement.

Some destination drivers accept a non-named parameter which is generally a path (the file and pipe driver accept a path) so an additional path property is provided alongside the parameters.

### Example 1

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

### Example 2

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
