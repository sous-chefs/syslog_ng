# TESTING

## Style Testing

Style tests can be performed by `foodcritic` and `cookstyle`

```shell
cookstyle .
foodcritic .
```

## Spec Testing

Unit testing is performed using ChefSpec, this will test all the libraries and then the resources via the recipes in the test cookbook.

```shell
chef exec rspec
```

or for more detail:

```shell
chef exec rspec -fd
```

## Integration Testing

Integration testing is performed using Test Kitchen. There are configurations to use Vagrant with either Virtualbox (default) or Hyper-V or Docker with dokken driver.

### Vagrant/Virtualbox

```shell
kitchen test
```

### Docker on Linux

```shell
export KITCHEN_YAML="kitchen.yml"
export KITCHEN_LOCAL_YAML="kitchen.dokken.yml"
kitchen test
```

### Docker on Windows

```shell
$env:KITCHEN_YAML="kitchen.yml"
$env:KITCHEN_LOCAL_YAML="kitchen.dokken.yml"
kitchen test
```

### CI Testing

CI testing is setup to run through Travis via Github
