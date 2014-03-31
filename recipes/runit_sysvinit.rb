#
# Copyright:: Copyright (c) 2013 Opscode, Inc.
#
# All Rights Reserved
#

project_name = node['enterprise']['name']
install_path = node[project_name]['install_path']
init_id = node[project_name]['sysvinit_id'] || 'SV'

# We assume you are sysvinit
svdir_line = '#{init_id}:123456:respawn:#{install_path}/embedded/bin/runsvdir-start'
execute "echo '#{svdir_line}' >> /etc/inittab" do
  not_if "grep '#{svdir_line}' /etc/inittab"
  notifies :run, "execute[init q]", :immediately
end

execute "init q" do
  action :nothing
end
