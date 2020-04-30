# syslog_ng_template

[Back to resource list](../README.md#resources)

See [usage](#template-usage) for examples.

## Actions

- `create` - Create a syslog-ng template configuration file
- `delete` - Remove a syslog-ng template configuration file

## Properties

| Property             | Optional? | Type        | Description                                                         |
|----------------------|-----------|-------------|---------------------------------------------------------------------|
| `config_dir`         | Yes       | String      | Directory to create config file, defaults to `/etc/syslog-ng/log.d` |
| `cookbook`           | Yes       | String      | Override cookbook to source the template file from                  |
| `template_source`    | Yes       | String      | Override the template source file                                   |
| `template`           | No        | String      | Template expression                                                 |
| `template_escape`    | Yes       | True, False | Escape the `'`, `"`, and `\` characters from the messages           |
| `description`        | Yes       | String      | Template statement description                                      |

## Usage

Generates a syslog-ng [template](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.22/administration-guide/62#TOPIC-1209309) configuration statement.

### Example 1

```ruby
syslog_ng_template 't_first_template' do
  template 'sample-text'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Template - t_first_template
template t_first_template {
    template("sample-text"); template-escape(no);
};
```

### Example 2

```ruby
syslog_ng_template 't_second_template' do
  template 'The result of the first-template is: $(template t_first_template)'
  notifies :run, 'execute[syslog-ng-config-test]', :delayed
  notifies :reload, 'service[syslog-ng]', :delayed
  action :create
end
```

Generates:

```c
# Template - t_second_template
template t_second_template {
    template("The result of the first-template is: $(template t_first_template)"); template-escape(no);
};
```
