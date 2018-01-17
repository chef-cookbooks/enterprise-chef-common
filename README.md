# enterprise cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/enterprise-chef-common.svg?branch=master)](http://travis-ci.org/chef-cookbooks/enterprise-chef-common)

This cookbook provides common functionality needed for Chef server, Push jobs, Reporting, and other enterprise-grade Omnibus projects.

Your omnibus project attributes should define the following attributes:

```
node['enterprise']['name']
```

This defaults to `private_chef` for back compat. If you are building top-level (non add-on) project, set it to your project name.

In addition, you need to have:

- `node[project_name]['install_path']` the install location for your omnibus project (e.g. `/opt/chef-server`).

Optional attributes are:

- `node[project_name]['sysvinit_id']` an identifier used in `/etc/inittab` (default is `'SV'`). Needs to be a unique (for the file) sequence of 1-4 characters.
- `node[project_name]['topology']` one of `standalone`, `tier`, or `ha`.
- `node[project_name]['role']` either `backend` or `frontend`.
- `node[project_name]['servers'][node_name]['bootstrap']` is used to determine if the node is installation bootstrap server. Value is treated as boolean.
- `node[project_name]['keepalived']['dir']` directory for keepalived.

## Recipes

### runit

Sets the proper attributes to use runit and creates a runit supervisor to be used by component runit services.

## Definitions

### component_runit_service

Defines a runit service.

## Resources

### component_runit_supervisor

Creates a runit runsvdir process to monitor component runit processes.

#### Properties

- `name` - The name of the project
- `ctl_name` - Name of the command used to manage the services. Defaults to `#{name}-ctl`.
- `sysvinit_id - Two-letter prefix used to identify the service on sysvinit-style systems. Defaults to`"SV"`.
- `install_path` - Path where the project is installed.

#### Actions

- `:create` - Create the necessary files and start the runsvdir service.
- `:delete` - Stop the services and the runsvdir service and remove the files.

#### Providers

- `Chef::Provider::ComponentRunitSupervisor::Systemd` - For systems using systemd.
- `Chef::Provider::ComponentRunitSupervisor::Sysvinit` - For systems using sysvinit.
- `Chef::Provider::ComponentRunitSupervisor::Upstart` - For systems using Upstart.

## Testing

[ChefDK](http://downloads.chef.io/chef-dk/) must be installed

### ChefSpec

Run `chef exec rspec` to run ChefSpec examples.

### Test Kitchen

Integration tests can be run with [Test Kitchen](http://kitchen.ci/).

## Maintainers

This cookbook is maintained by Chef's Community Cookbook Engineering team. Our goal is to improve cookbook quality and to aid the community in contributing to cookbooks. To learn more about our team, process, and design goals see our [team documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/COOKBOOK_TEAM.MD). To learn more about contributing to cookbooks like this see our [contributing documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/CONTRIBUTING.MD), or if you have general questions about this cookbook come chat with us in #cookbok-engineering on the [Chef Community Slack](http://community-slack.chef.io/)

## License

**Copyright:** 2013-2017, Chef Software, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
