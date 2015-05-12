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
