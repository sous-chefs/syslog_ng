# syslog_ng_package

[Back to resource list](../README.md#resources)

## Actions

- `:install` - Install Syslog-NG
- `:upgrade` - Upgrade Syslog-NG
- `:remove` - Uninstall Syslog-NG

## Properties

| Name                         | Type          | Default                         | Description                                                | Allowed Values |
| ---------------------------- | ------------- | ------------------------------- | ---------------------------------------------------------- | -------------- |
| `packages`                   | String, Array | All Syslog-NG packages in repos | Packages to install                                        |                |
| `packages_exclude`           | String, Array | `[]`                            | Package to exclude via `String.match?()`                   |                |
| `package_repository`         | String        |                                 | Package repository/repositories to install from            |                |
| `package_repository_exclude` | String, Array | `[]`                            | Package repository/repositories to exclude when installing |                |

## Usage

By default the resource will install all Syslog-NG packages available in the system package repositories, use the `package_repository` to specify a specific repository to source the packages to install from in the case of package conflicts when not using distro packages.

### Default installation

```ruby
syslog_ng_install '' do
  action :install
end
```

### Install with excluded packages

```ruby
syslog_ng_install '' do
  packages_exclude %w(syslog-ng-debuginfo, syslog-ng-devel)
  action :install
end
```

### Uninstall

```ruby
syslog_ng_install '' do
  action :remove
end
```
