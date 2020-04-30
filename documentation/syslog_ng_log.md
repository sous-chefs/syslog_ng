# syslog_ng_log

[Back to resource list](../README.md#resources)

See [usage](#log-usage) for examples.

## Actions

- `create` - Create a syslog-ng log configuration file
- `delete` - Remove a syslog-ng log configuration file

## Properties

| Property          | Optional? | Type                | Description                                                                  |
|-------------------|-----------|---------------------|------------------------------------------------------------------------------|
| `config_dir`      | Yes       | String              | Directory to create config file, defaults to `/etc/syslog-ng/log.d`          |
| `cookbook`        | Yes       | String              | Override cookbook to source the template file from                           |
| `template_source` | Yes       | String              | Override the template source file                                            |
| `source`          | Yes       | String, Array, Hash | The source directive(s) to reference                                         |
| `filter`          | Yes       | String, Array, Hash | The filter directive(s) to reference                                         |
| `destination`     | Yes       | String, Array, Hash | The destination directive(s) to reference                                    |
| `flags`           | Yes       | String, Array       | The log path flags to use                                                    |
| `parser`          | Yes       | String, Array       | The log parser to use                                                        |
| `junction`        | Yes       | Hash, Array         | Specify a log junction and contained channels                                |
| `description`     | Yes       | String              | Log statement description                                                    |

## Usage

Generates a syslog-ng [log](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.22/administration-guide/53#TOPIC-1209271) configuration statement.

A log statement is the last part of a combination of `source`, `filter` and `destination` resources to create a completed log configuration with syslog-ng. Multiple source, filter and destination elements can be passed to the resource as a String Array.

*The resource does not presently support embedded log statements, this will be added as a future development.*

### Example 1 - Basic Log

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

### Example 2 - Contained Log

```ruby
syslog_ng_log 'l_test_embedded' do
  source(
    [
      'tcp' => {
        'parameters' => {
          'ip' => '127.0.0.1',
          'port' => '5516',
        },
      },
      'udp' => {
        'parameters' => {
          'ip' => '127.0.0.1',
          'port' => '5516',
        },
      },
    ]
  )
  filter(
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
  destination(
    [
      {
        'file' => {
          'path' => '/var/log/embedded_test/test_file_1.log',
          'parameters' => {
            'flush_lines' => 10,
            'create-dirs' => 'yes',
          },
        },
      },
      {
        'file' => {
          'path' => '/var/log/embedded_test/test_file_2.log',
          'parameters' => {
            'flush_lines' => 100,
            'create-dirs' => 'yes',
          },
        },
      },
    ]
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Log - l_test_embedded
log {
    source { tcp(ip(127.0.0.1) port("5516")); };
    source { udp(ip(127.0.0.1) port("5516")); };
    filter { ((facility(mail)) and (facility(cron) or facility(authpriv))) };
    destination { file("/var/log/embedded_test/test_file_1.log" flush_lines(10) create-dirs(yes)); };
    destination { file("/var/log/embedded_test/test_file_2.log" flush_lines(100) create-dirs(yes)); };
};
```

### Example 3 - Log Junction/Channels

```ruby
syslog_ng_log 'l_test_junction' do
  source(
    [
      'tcp' => {
        'parameters' => {
          'ip' => '127.0.0.1',
          'port' => '5520',
          'flags' => 'no-parse',
        },
      },
    ]
  )
  destination(
    [
      {
        'file' => {
          'path' => '/var/log/junction_test/test_file_junction.log',
          'parameters' => {
            'flush_lines' => 10,
            'create-dirs' => 'yes',
          },
        },
      },
    ]
  )
  junction(
    [
      {
        'filter' => 'f_test',
        'parser' => {
          'parser' => 'syslog-parser',
        },
      },
      {
        'filter' => 'f_test_contained',
      },
    ]
  )
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Log - l_test_junction
log {
    source { tcp(ip(127.0.0.1) port("5520") flags("no-parse")); };
    junction {
        channel {
            filter(f_test);
            parser {
                syslog-parser(
                );
            };
        };
        channel {
            filter(f_test_contained);
        };
    };
    destination { file("/var/log/junction_test/test_file_junction.log" flush_lines(10) create-dirs(yes)); };
};
```
