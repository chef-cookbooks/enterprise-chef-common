# Enterprise Cookbook Change Log

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
