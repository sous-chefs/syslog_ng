# syslog_ng_template

[Back to resource list](../README.md#resources)

## Actions

- `:create` - Create a syslog-ng template configuration file
- `:delete` - Remove a syslog-ng template configuration file

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
| `template_expression`  | String, Array |                                  | Template expression                                                 |                     |
| `template_escape`      | True, False   | `false`                          | Escape the `'`, `"`, and `\` characters from the messages           |                     |

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
