#
# Copyright:: Copyright (c) 2015 Opscode, Inc.
#
# All Rights Reserved
#

project_name = node['enterprise']['name']
unit_name = "#{project_name}-runsvdir-start.service"

template "/usr/lib/systemd/system/#{unit_name}" do
  owner "root"
  group "root"
  mode "0644"
  variables({
              :install_path => node[project_name]['install_path'],
              :project_name => project_name
  })
  source "runsvdir-start.service.erb"
end

service unit_name do
  action [:enable, :start]
  provider Chef::Provider::Service::Systemd
end
