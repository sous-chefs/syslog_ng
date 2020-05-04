# syslog_ng_filter

[Back to resource list](../README.md#resources)

## Actions

- `create` - Create a syslog-ng filter configuration file
- `delete` - Remove a syslog-ng filter configuration file

## Properties

| Name                   | Type          | Default                          | Description                                                         | Allowed Values      |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- | ------------------- |
| `config_dir`           | String        | /etc/syslog-ng/filter.d          | Directory to create configuration file in                           |                     |
| `cookbook`             | String        | syslog-ng                        | Cookbook to source configuration file template from                 |                     |
| `template`             | String        | syslog-ng/filter.conf.erb        | Template to use to generate the configuration file                  |                     |
| `owner`                | String        | root                             | Owner of the generated configuration file                           |                     |
| `group`                | String        | root                             | Group of the generated configuration file                           |                     |
| `mode`                 | String        | `'0640'`                         | Filemode of the generated configuration file                        |                     |
| `description`          | String        |                                  | Unparsed description to add to the configuration file               |                     |
| `parameters`           | Hash, Array, String |                            | Filter(s) parameters and options                                    |                     |

## Usage

Generates a syslog-ng [filter](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.25/administration-guide/57#TOPIC-1349510) configuration statement.

Due to the large amount of possible combinations of Boolean operators and containers to which can be applied in a filter, this resource has a reasonably complex Hash structure and despite trying to break this as much as possible in testing, this library will very likely have some bugs in it.

In the case of the library being unable to generate a filter there is the option of giving the correctly formatted filter as a String or as an Array of String, in this case it is up to the implementer to ensure that it is a correctly formatted filter statement for syslog-ng.

### Example 1 - Contained OR'd common filters

Hash:

```ruby
syslog_ng_filter 'f_test' do
  parameters(
    'container' => {
      'operator' => 'or',
      'facility' => %w(mail authpriv cron),
    }
  )
  action :create
end
```

Generates:

```c
filter f_test {
  (facility(mail) or facility(authpriv) or facility(cron));
};
```

### Example 2 - Multiple contained groups with differing operators

Hash:

```ruby
syslog_ng_filter 'f_test_contained' do
  parameters(
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
  action :create
end
```

Generates:

```c
filter f_test_contained {
  ((facility(mail)) and (facility(cron) or facility(authpriv)));
};
```

### Example 3 - Multiple of the same filter given as an Array

- syslog-ng implicitly takes multiple filters within a contained group **without** a Boolean operator as being `and`'d so the library explicitly specifies it if no other operator has been given.

```ruby
syslog_ng_filter 'f_test_array_and' do
  parameters(
    'container' => {
      'facility' => %w(mail authpriv cron),
    }
  )
  action :create
end
```

Generates:

```c
filter f_test_array {
  (facility(mail) and facility(authpriv) and facility(cron));
};
```

- The same with an `or` operator specified

```ruby
syslog_ng_filter 'f_test_array_or' do
  parameters(
    'container' => {
      'operator' => 'or',
      'facility' => %w(mail authpriv cron),
    }
  )
  action :create
end
```

Generates:

```c
filter f_test_array_or {
  (facility(mail) or facility(authpriv) or facility(cron));
};
```

### Example 4 - Pass a raw filter String

```ruby
syslog_ng_filter 'f_test_raw_string' do
  parameters 'host("example") and match("deny" value("MESSAGE"))'
  action :create
end
```

Generates:

```c
filter f_test_raw_string {
    host("example") and match("deny" value("MESSAGE"));
};
```

### Example 5 - Pass a raw filter Array

```ruby
syslog_ng_filter 'f_test_raw_string_array' do
  parameters ['host("example1")', 'or host("example2")', 'or (host("example3") and not match("test" value("NOT_ME_MESSAGE")))']
  action :create
end
```

Generates:

```c
filter f_test_raw_string_array {
    host("example1") or host("example2") or (host("example3") and not match("test" value("NOT_ME_MESSAGE")));
};
```
