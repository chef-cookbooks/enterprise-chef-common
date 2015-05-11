#
# Copyright:: Copyright (c) 2013 Opscode, Inc.
#
# All Rights Reserved
#

project_name = node['enterprise']['name']
node.default_unless[node['enterprise']['name']] = {} # ~FC047 (See https://github.com/acrmp/foodcritic/issues/225)
install_path = node[project_name]['install_path']

node.set['runit']['sv_bin']       = "#{install_path}/embedded/bin/sv"
node.set['runit']['svlogd_bin']   = "#{install_path}/embedded/bin/svlogd"
node.set['runit']['chpst_bin']    = "#{install_path}/embedded/bin/chpst"
node.set['runit']['service_dir']  = "#{install_path}/service"
node.set['runit']['sv_dir']       = "#{install_path}/sv"
node.set['runit']['lsb_init_dir'] = "#{install_path}/init"

if node['init_package'] == 'systemd'
  include_recipe 'enterprise::runit_systemd'
else
  case node['platform_family']
  when 'debian'
    case node['platform']
    when 'debian'
      include_recipe 'enterprise::runit_sysvinit'
    else
      include_recipe 'enterprise::runit_upstart'
    end
  when 'fedora', 'rhel'
    case node['platform']
    when 'amazon', 'fedora'
      include_recipe 'enterprise::runit_upstart'
    else
      if node['platform_version'] =~ /^6/
        include_recipe 'enterprise::runit_upstart'
      else
        include_recipe 'enterprise::runit_sysvinit'
      end
    end
  else
    include_recipe 'enterprise::runit_sysvinit'
  end
end
