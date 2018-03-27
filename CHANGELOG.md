# Enterprise Cookbook Change Log

This file is used to list changes made in each version of the enterprise cookbook.

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
