enterprise cookbook
===================

This cookbook provides common functionality needed for Enterprise
Chef, Pushy, Reporting, and other enterprise-grade Omnibus projects.

Your omnibus project attributes should define the following attributes:

    node['enterprise']['name']

This defaults to `private_chef` for back compat. If you are building
top-level (non add-on) project, set it to your project name.

In addition, you need to have:

    node[project_name]['install_path']
    node[project_name]['sysvinit_id']
    node[project_name]['topology']
    node[project_name]['role']
    node[project_name]['servers'][node_name]['bootstrap']
    node[project_name]['keepalived']['dir']
