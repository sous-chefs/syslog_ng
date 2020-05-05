# syslog_ng_source

[Back to resource list](../README.md#resources)

## Actions

- `:create` - Create a syslog-ng source configuration file
- `:delete` - Remove a syslog-ng source configuration file

## Properties

| Name                   | Type          | Default                          | Description                                                         | Allowed Values      |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- | ------------------- |
| `config_dir`           | String        | `/etc/syslog-ng/destionation.d`  | Directory to create configuration file in                           |                     |
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

Generates a syslog-ng [source](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.25/administration-guide/17#TOPIC-1349351) configuration statement.

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
