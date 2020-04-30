# syslog_ng_parser

[Back to resource list](../README.md#resources)

See [usage](#parser-usage) for examples.

## Actions

- `create` - Create a syslog-ng parser configuration file
- `delete` - Remove a syslog-ng parser configuration file

## Properties

| Property             | Optional? | Type                | Description                                                                  |
|----------------------|-----------|---------------------|------------------------------------------------------------------------------|
| `config_dir`         | Yes       | String              | Directory to create config file, defaults to `/etc/syslog-ng/log.d`          |
| `cookbook`           | Yes       | String              | Override cookbook to source the template file from                           |
| `template_source`    | Yes       | String              | Override the template source file                                            |
| `parser`             | Yes       | String, Array, Hash | The parser type to use                                                       |
| `parser_options`     | Yes       | String, Array, Hash | Parser type configuration options                                            |
| `additional_options` | Yes       | Hash                | Additional parser options                                                    |
| `description`        | Yes       | String              | Parser statement description                                                 |

## Usage

Generates a syslog-ng [parser](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.22/administration-guide/67#TOPIC-1209329) configuration statement.

### Example 1 - CSV Parser

```ruby
syslog_ng_parser 'p_csv_parser' do
  parser 'csv-parser'
  parser_options 'columns' => '"HOSTNAME.NAME", "HOSTNAME.ID"', 'delimiters' => '"-"', 'flags' => 'escape-none', 'template' => '"${HOST}"'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Parser - p_csv_parser
parser p_csv_parser {
    csv-parser(
        columns("HOSTNAME.NAME", "HOSTNAME.ID")
        delimiters("-")
        flags(escape-none)
        template("${HOST}")
    );
};
```

### Example 2 - iptables Parser

```ruby
syslog_ng_parser 'p_iptables_parser' do
  parser 'iptables-parser'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Parser - p_iptables_parser
parser p_iptables_parser {
    iptables-parser(
    );
};
```

### Example 3 - JSON Parser

```ruby
syslog_ng_parser 'p_json_parser' do
  parser 'json-parser'
  parser_options 'prefix' => '".json."', 'marker' => '"@json:"'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Parser - p_json_parser
parser p_json_parser {
    json-parser(
        prefix(".json.")
        marker("@json:")
    );
};
```
