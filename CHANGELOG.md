# Enterprise Cookbook Change Log

This file is used to list changes made in each version of the enterprise cookbook.

## 0.15.2 (2020-06-02)

- Update file headers to match our standard - [@tas50](https://github.com/tas50)
- Cookstyle fixes including Chef Infra Client 16 compatibility - [@xorimabot](https://github.com/xorimabot)
  - resolved cookstyle error: libraries/component_runin_supervisor_resource_mixin.rb:4:7 warning: `ChefDeprecations/ResourceUsesOnlyResourceName`
  - resolved cookstyle error: resources/component_runit_service.rb:21:1 warning: `ChefDeprecations/ResourceUsesOnlyResourceName`
  - resolved cookstyle error: recipes/runit.rb:18:53 convention: `Layout/TrailingWhitespace`
  - resolved cookstyle error: recipes/runit.rb:18:54 refactor: `ChefModernize/FoodcriticComments`
  - resolved cookstyle error: libraries/dsl.rb:28:14 warning: `Lint/SendWithMixinArgument`
  - resolved cookstyle error: libraries/dsl.rb:29:16 warning: `Lint/SendWithMixinArgument`
  - resolved cookstyle error: libraries/dsl.rb:30:16 warning: `Lint/SendWithMixinArgument`
  - resolved cookstyle error: libraries/dsl.rb:35:26 warning: `Lint/SendWithMixinArgument`
  - resolved cookstyle error: metadata.rb:6:1 refactor: `ChefRedundantCode/LongDescriptionMetadata`
  - resolved cookstyle error: resources/component_runit_service.rb:36:1 refactor: `ChefStyle/TrueClassFalseClassResourceProperties`
  - resolved cookstyle error: resources/pg_user.rb:3:1 refactor: `ChefStyle/TrueClassFalseClassResourceProperties`

## 0.15.1 (2019-06-02)

- Minor testing updates and metadata fixes - [@tas50](https://github.com/tas50)

## 0.15.0 (2019-06-03)

- Update for and require the new runit cookbook v5.0.1
- Remove support for keepalived in Chef HA
- Remove the ChefSpec matchers that are no longer necessary with modern ChefSpec
- Remove fedora from the metadata since we don't actually support it
- Refactor component_runit_service to use the new :reload_log action in runit cookbook 5.X's runit_service resource
- Require Chef 13 or later
- Remove support for Debian < 8 and RHEL < 6
- Update the specs for modern platforms

## 0.14.2 (2018-11-28)

- turn component_runit_service into a custom resource [\#67]

## 0.14.1 (2018-08-15)

- Pin runit cookbook to v4.1.1.

## 0.14.0 (2018-05-18)

- Make specs Chef 14 friendly
- Add Ubuntu 18 support
- Rework specs to use InSpec to detect init system
- Set systemd TasksMax to infinity where supported
    This fixes an issue where the JVM ran out of processes.

## 0.13.0 (2018-03-27)

- Resolve Chef 14 deprecation warnings

## 0.12.0 (2018-01-17)

- Reload the systemd unit files anytime we make changes
- Convert pg LWRPs to custom resources
- Increase the minimum supported chef-client to 12.7
- Move templates out of the default directory since only Chef 11 requires that
- Minor cleanup to the test recipe and configs
- Convert broken ServerSpec tests to InSpec

## 0.11.0 (2017-07-12)

- Convert the library LWRPs to custom resources
- [CLOUD-429] Fix runsvdir reboot issues with Upstart
- Update enterprise_pg_database and specs to be chef 13.x compatible
- Avoid deprecation warnings in chefspec

## 0.10.2 (2016-08-10)

* Add directive to systemd file to wait for network to be up to avoid process (elasticsearch) coming up thinking there is no network configured.

## 0.10.1 (2016-06-07)

* Put systemd unit files in /etc/systemd/system; clean up files previously placed
  in /usr/lib/systemd/system.

## 0.10.0 (2016-02-11)

* SUSE support.

## 0.9.0 (2015-10-08)

* Relax RuboCop rules
* Ensure `component_runit_supervisor` `:delete` action does not attempt to run a
  command that does not exist
* Add basic ChefSpec convergence coverage
* Update Travis configuration to run using ChefDK

## 0.8.0 (2015-06-09)

* Add Gemfile
* Fix for empty resource definitions overwriting environment variables
* Update Postgres credentials to utilize environment variables

## 0.7.1 (2015-06-05)

* Fix bug with undefined variable in pg\_user and pg\_database resources

## 0.7.0 (2015-06-03)

* Add delete action for component runit supervisor resource

## 0.6.0 (2015-06-03)

* Add support for external Postgres databases

## 0.5.2 (2015-02-05)

* Add svlogd bin attribute for runit

## 0.5.1 (2015-01-15)

* Make it possible to pass arbitrary attrs to runit resources
* Add systemd support

## 0.4.7 (2014-11-19)

* Reload logging service on config changes

## 0.4.6 (2014-11-06)

* Apply Apache 2.0 license
* Allow project to override the name of the ctl script

## 0.4.5 (2014-09-03)

* Unbreak private-chef package upgrades, since package\_name of private\_chef causes major issues
* Don't mess with `install_path` and also don't mess with `node['enterprise']['name']` downstream by cloning it

## 0.4.4 (2014-07-18)

* [OC-11575] Don't start services by default in HA topology

## 0.4.3 (2014-05-27)

* Unbreak runit setup on sysv style init (RHEL5)

## 0.4.2 (2014-05-13)

* Enable a cluster's default encoding to be specified
