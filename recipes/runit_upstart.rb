#
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

project_name = node['enterprise']['name'].clone
project_name.gsub!(/_/, '-') if project_name == 'private_chef'

ctl_name = node[node['enterprise']['name']]['ctl_name'] || "#{project_name}-ctl"

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
              :ctl_name => ctl_name
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
