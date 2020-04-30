# syslog_ng_source

[Back to resource list](../README.md#resources)

See [usage](#source-usage) for examples.

## Actions

- `create` - Create a syslog-ng source configuration file
- `delete` - Remove a syslog-ng source configuration file

## Properties

| Property        | Optional? | Type           | Description                                                                  |
|-----------------|-----------|---------------|------------------------------------------------------------------------------|
| `config_dir`    | Yes       | String        | Directory to create config file, defaults to `/etc/syslog-ng/source.d`       |
| `cookbook`      | Yes       | String        | Override cookbook to source the template file from                           |
| `source`        | Yes       | String, Array | Override the template source file                                            |
| `driver`        | No        | String, Array | The source driver to use                                                     |
| `parameters`    | Yes       | Hash, Array   | Driver parameters and options                                                |
| `configuration` | Yes       | Array         | Array of Hash containing raw driver(s) configuration                         |
| `description`   | Yes       | String        | Source statement description                                                 |
| `multiline`     | Yes       | True, False   | Use multiline formatting, default is false                                   |

## Usage

Generates a syslog-ng [source](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.22/administration-guide/16#TOPIC-1209125) configuration statement.

### Example 1 - TCP source

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

### Example 2 - Wildcard source

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

### Example 3 - Syslog source

```ruby
syslog_ng_source 's_test_syslog' do
  driver 'syslog'
  parameters(
    'ip' => '127.0.0.1',
    'port' => '3381',
    'max-connections' => 100,
    'log_iw_size' => 10000,
    "use_dns" => :persist_only
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Source - s_test_syslog
source s_test_syslog {
    syslog(ip(127.0.0.1) port("3381") max-connections(100) log_iw_size(10000) use_dns(persist_only));
};
```
