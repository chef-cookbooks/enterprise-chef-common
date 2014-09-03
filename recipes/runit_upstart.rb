#
# Copyright:: Copyright (c) 2013 Opscode, Inc.
#
# All Rights Reserved
#

project_name = node['enterprise']['name'].clone
project_name.gsub!(/_/, '-') if project_name == 'private_chef'

# Ensure the previous named iteration of the system job is nuked
execute "initctl stop opscode-runsvdir" do
  only_if "initctl status opscode-runsvdir | grep start"
  retries 30
end

file "/etc/init/opscode-runsvdir.conf" do
  action :delete
end

template "/etc/init/#{project_name}-runsvdir.conf" do
  owner "root"
  group "root"
  mode "0644"
  variables({
              :install_path => node[node['enterprise']['name']]['install_path'],
              :project_name => project_name
  })
  source "init-runsvdir.erb"
end

# Keep on trying till the job is found :(
execute "initctl status #{project_name}-runsvdir" do
  retries 30
end

# If we are stop/waiting, start
#
# Why, upstart, aren't you idempotent? :(
execute "initctl start #{project_name}-runsvdir" do
  only_if "initctl status #{project_name}-runsvdir | grep stop"
  retries 30
end
