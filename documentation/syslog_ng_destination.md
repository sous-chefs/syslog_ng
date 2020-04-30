# syslog_ng_destination

[Back to resource list](../README.md#resources)

See [usage](#destination-usage) for examples.

## Actions

- `create` - Create a syslog-ng destination configuration file
- `delete` - Remove a syslog-ng destination configuration file

## Properties

| Property        | Optional? | Type          | Description                                                                  |
|-----------------|-----------|---------------|------------------------------------------------------------------------------|
| `config_dir`    | Yes       | String        | Directory to create config file, defaults to `/etc/syslog-ng/destination.d`  |
| `cookbook`      | Yes       | String        | Override cookbook to source the template file from                           |
| `source`        | Yes       | String        | Override the template source file                                            |
| `driver`        | No        | String, Array | The destination driver to use                                                |
| `path`          | Yes       | String, Array | The path for the destination driver (if it supports being specified one)     |
| `parameters`    | Yes       | Hash, Array   | Driver parameters and options                                                |
| `configuration` | Yes       | Array         | Array of Hash containing raw driver(s) configuration                         |
| `multiline`     | Yes       | True, False   | Use multiline formatting, default is false                                   |

## Usage

[**Resource**](#destination)

Generates a syslog-ng [destination](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.22/administration-guide/29#TOPIC-1209176) configuration statement.

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
