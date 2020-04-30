# syslog_ng_package

See [usage](#install-usage) for examples.

## Actions

- `install` - Install syslog-ng
- `remove` - Uninstall syslog-ng

## Properties

| Property         | Optional? | Type        | Description                                                                  |
|------------------|-----------|-------------|------------------------------------------------------------------------------|
| `package_source` | Yes       | String      | Package source selection choices are `distro`, `latest` or `githead`         |
| `remove_rsyslog` | Yes       | True, False | Remove rsyslog package during installation, otherwise disable the service    |
| `repo_cleanup`   | Yes       | True, False | Clean up superseded repository configuration files                           |

## Usage

There following installation methods are available:

- `distro`
- `latest`
- `githead`

The latest installation method is available to current Redhat (7+), Fedora (28+) and Debian distributions and provide up-to-dates versions that aren't in the distribution repositories. The githead method is only available to Redhat and Fedora distributions as a build of the latest code from the syslog-ng repository.

By default the resource will remove rsyslog which is the default syslog daemon on the supported distros, if this is set to `false` then the rsyslog service will just be disabled instead. **Some package managers will remove rsyslog anyway when installing syslog-ng so even if this set to `false` rsyslog can still be removed.**

The `syslog_ng_install` resource does not require a name property.

### Distribution repository package installation

```ruby
syslog_ng_install '' do
  action :install
end
```

### COPR repository package installation

```ruby
syslog_ng_install '' do
  package_source 'package_copr'
  action :install
end
```

### Uninstall

```ruby
syslog_ng_install '' do
  action :remove
end
```
