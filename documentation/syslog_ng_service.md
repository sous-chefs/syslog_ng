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
| `config_test`          | True, False   | `true`                           | Perform a configuration file test before performing service action  |                     |

### Example

```ruby
syslog_ng_service 'syslog-ng' do
  action [:enable, :start]
end
```
