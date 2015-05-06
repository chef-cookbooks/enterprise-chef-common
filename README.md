enterprise cookbook
===================

This cookbook provides common functionality needed for Chef server,
Push jobs, Reporting, and other enterprise-grade Omnibus projects.

Your omnibus project attributes should define the following attributes:

    node['enterprise']['name']

This defaults to `private_chef` for back compat. If you are building
top-level (non add-on) project, set it to your project name.

In addition, you need to have:

* `node[project_name]['install_path']` the install location for your
  omnibus project (e.g. `/opt/opscode`).
* `node[project_name]['sysvinit_id']` an identifier used in
    `/etc/inittab` (default is `'SV'`). Needs to be a unique (for the
    file) sequence of 1-4 characters.
* `node[project_name]['topology']` one of `standalone`, `tier`, or `ha`.
* `node[project_name]['role']` either `backend` or `frontent`.
* `node[project_name]['servers'][node_name]['bootstrap']` is used to
  determine if the node is installation bootstrap server. Value is
  treated as boolean.
* `node[project_name]['keepalived']['dir']` directory for keepalived.

## Testing

[ChefDK](http://downloads.chef.io/chef-dk/) must be installed (version 0.5.1 at
the time of this writing.)

Run `chef exec rspec` to run ChefSpec examples.

## License

All files in the repository are licensed under the Apache 2.0 license. If any
file is missing the License header it should assume the following is attached;

```
Copyright 2014-2015 Chef Software, Inc.

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
