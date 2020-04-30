# syslog_ng_rewrite

[Back to resource list](../README.md#resources)

See [usage](#rewrite-usage) for examples.

## Actions

- `create` - Create a syslog-ng rewrite configuration file
- `delete` - Remove a syslog-ng rewrite configuration file

## Properties

| Property             | Optional? | Type          | Description                                                                  |
|----------------------|-----------|---------------|------------------------------------------------------------------------------|
| `config_dir`         | Yes       | String        | Directory to create config file, defaults to `/etc/syslog-ng/rewrite.d`      |
| `cookbook`           | Yes       | String        | Override cookbook to source the template file from                           |
| `template_source`    | Yes       | String        | Override the template source file                                            |
| `function`           | No        | String        | Rewrite function                                                             |
| `match`              | Yes       | String        | String or regular expression to find                                         |
| `replacement`        | Yes       | String        | Replacement string                                                           |
| `field`              | Yes       | String        | Field to match against---                                                    |
| `value`              | Yes       | String        | Value to apply rewrite action to (Field name)                                |
| `values`             | Yes       | String, Array | Values to apply rewrite action to (Field name or Glob pattern)               |
| `flags`              | Yes       | String, Array | Flag(s) to apply                                                             |
| `tags`               | Yes       | String        | Tags to apply                                                                |
| `condition`          | Yes       | String        | Condition which must be satisfied for the rewrite to be applied              |
| `additional_options` | Yes       | Hash          | Additional options for template function                                     |
| `configuration`      | Yes       | Array         | Array of Hash containing raw rewrite(s) configuration                        |
| `description`        | Yes       | String        | Rewrite statement description                                                |

## Usage

Generates a syslog-ng [rewrite](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.22/administration-guide/64#TOPIC-1209316) configuration statement.

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
