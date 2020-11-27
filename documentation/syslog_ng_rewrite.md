# syslog_ng_rewrite

[Back to resource list](../README.md#resources)

## Actions

- `:create` - Create a syslog-ng rewrite configuration file
- `:delete` - Remove a syslog-ng rewrite configuration file
- `:enable` - Enable a pre-existing syslog-ng rewrite configuration file
- `:disable` - Disable a pre-existing syslog-ng rewrite configuration file

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
| `function`             | String        |                                  | Rewrite function                                                    |                     |
| `match`                | String        |                                  | String or regular expression to find                                |                     |
| `replacement`          | String        |                                  | Replacement string                                                  |                     |
| `field`                | String        |                                  | Field to match against                                              |                     |
| `value`                | String        |                                  | Value to apply rewrite action to (Field name)                       |                     |
| `values`               | String, Array |                                  | Values to apply rewrite action to (Field name or Glob pattern)      |                     |
| `flags`                | String, Array |                                  | Flag(s) to apply                                                    |                     |
| `tags`                 | String        |                                  | Tags to apply                                                       |                     |
| `condition`            | String        |                                  | Condition which must be satisfied for the rewrite to be applied     |                     |
| `additional_options`   | Hash          |                                  | Additional options for rewrite function                             |                     |
| `configuration`        | Array         |                                  | Hash or Array of Hash containing raw rewrite(s) configuration       |                     |

## Usage

Generates a syslog-ng [rewrite](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.25/administration-guide/65#TOPIC-1349541) configuration statement.

### Example 1 - Substitute string `IP` with `IP-Address` in MESSAGE field

```ruby
syslog_ng_rewrite 'r_test_ip' do
  function 'subst'
  match 'IP'
  replacement 'IP-Address'
  value 'MESSAGE'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Rewrite - r_test_ip
rewrite r_test_ip {
    subst("IP", "IP-Address", value("MESSAGE"));
};
```

### Example 2 - Set the HOST field to `myhost`

```ruby
syslog_ng_rewrite 'r_test_set' do
  function 'set'
  replacement 'myhost'
  value 'HOST'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Rewrite - r_test_set
rewrite r_test_set {
    set("myhost", value("HOST"));
};
```

### Example 3 - Set the HOST field to `$MESSAGE suffix` with additional options

```ruby
syslog_ng_rewrite 'r_test_set_additional' do
  function 'set'
  replacement '$MESSAGE suffix'
  value 'HOST'
  additional_options 'on-error' => 'fallback-to-string'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Rewrite - r_test_set_additional
rewrite r_test_set_additional {
    set("$MESSAGE suffix", value("HOST") on-error("fallback-to-string"));
};
```

### Example 4 - Set tags

```ruby
syslog_ng_rewrite 'r_test_set_tag' do
  function 'set-tag'
  tags 'tag-to-add-1'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Rewrite - r_test_set_tag
rewrite r_test_set_tag {
    set-tag("tag-to-add-1");
};
```

### Example 5 - Multiple rewrite operations

```ruby
syslog_ng_rewrite 'r_test_multiple' do
  configuration(
    [
      {
        'function' => 'set-tag'
        'tags' => 'tag-to-add-1'
      },
      {
        'function' => 'clear-tag',
        'tags' => 'tag-to-clear-1'
      },
      {
        'function' => 'groupset',
        'field' => 'myhost',
        'values' => %w(HOST FULLHOST)
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
# Rewrite - r_test_multiple
rewrite r_test_multiple {
    set-tag("tag-to-add-1");
    clear-tag("tag-to-clear-1");
    groupset("myhost", values("HOST", "FULLHOST"));
};
````
