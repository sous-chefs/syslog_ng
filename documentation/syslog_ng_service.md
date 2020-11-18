# syslog_ng_service

[Back to resource list](../README.md#resources)

## Actions

- `:start`
- `:stop`
- `:restart`
- `:reload`
- `:enable`
- `:disable`

## Properties

| Name                   | Type          | Default                          | Description                                                         | Allowed Values      |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- | ------------------- |
| `service_name`         | String        | `syslog-ng`                      | The service name to perform actions upon                            |                     |
| `config_file`          | String        | `/etc/syslog-ng/syslog-ng.conf`  | The full path to the syslog-ng server configuration on disk         |                     |
| `config_test`          | True, False   | `true`                           | Perform a configuration file test before performing service action  |                     |
| `config_test_fail_action` | Symbol     | `:raise`                         | Action to perform upon a configuration test failure                 | `:raise`, `:log`    |

### Example

```ruby
syslog_ng_service 'syslog-ng' do
  action [:enable, :start]
end
```
