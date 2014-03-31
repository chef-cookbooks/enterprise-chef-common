enterprise cookbook
===================

This cookbook provides common functionality needed for Enterprise
Chef, Pushy, Reporting, and other enterprise-grade Omnibus projects.

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

Run `bundle exec rspec` (after running `bundle install`) to run ChefSpec examples.
