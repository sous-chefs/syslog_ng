# syslog_ng_block

[Back to resource list](../README.md#resources)

## Actions

- `:create` - Create a syslog-ng block configuration file
- `:delete` - Remove a syslog-ng block configuration file
- `:enable` - Enable a pre-existing syslog-ng block configuration file
- `:disable` - Disable a pre-existing syslog-ng block configuration file

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
| `type`                 | Symbol        |                                  | Block type                                                          | `:destination`, `:filter`, `:log`, `:options`, `:parser`, `:rewrite`, `:root`, `:source` |
| `parameters`           | Hash          |                                  | Block parameters and default values, use `:empty` to have no default|                     |
| `definition`           | Hash          |                                  | Hash or Array of Hash containing raw driver(s) configuration        |                     |

## Usage

Generates a syslog-ng [block](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.25/administration-guide/16#TOPIC-1349347) configuration statement.

### Example 1 - TCP source block

```ruby
syslog_ng_block 'b_test_tcp_source_block' do
  type :source
  parameters(
    'localport' => :empty,
    'flags' => '""'
  )
  definition(
    'network' => {
      'port' => '`localport`',
      'transport' => 'tcp',
      'flags' => '`flags`',
    }
  )
  action :create
end
```

Generates:

```c
block source b_test_tcp_source_block(localport() flags("")) {
  network(
    port(`localport`)
    transport("tcp")
    flags(`flags`)
  );
};
```

### Example 2 - File destination block

```ruby
syslog_ng_block 'b_test_file_destination_block' do
  type :destination
  parameters(
    'file' => :empty
  )
  definition(
    'file' => {
      'path' => '`file`',
      'flush_lines' => 10,
      'create-dirs' => 'yes',
    }
  )
  action :create
end
```

Generates:

```c
block destination b_test_file_destination_block(file()) {
  file(
    `file`
    flush_lines(10)
    create-dirs(yes)
  );
};
```
