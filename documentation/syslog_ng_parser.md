# syslog_ng_parser

[Back to resource list](../README.md#resources)

## Actions

- `:create` - Create a syslog-ng parser configuration file
- `:delete` - Remove a syslog-ng parser configuration file
- `:enable` - Enable a pre-existing syslog-ng parser configuration file
- `:disable` - Disable a pre-existing syslog-ng parser configuration file

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
| `parser`               | String        |                                  | Parser driver                                                       |                     |
| `options`              | Hash          |                                  | Parser driver configuration options                                 |                     |

## Usage

Generates a syslog-ng [parser](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.25/administration-guide/69#TOPIC-1349555) configuration statement.

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
