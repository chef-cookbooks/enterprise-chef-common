#
# Copyright:: Copyright (c) 2013-2015 Chef Software, Inc.
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
    include_recipe 'enterprise::runit_upstart'
  when 'fedora', 'rhel'
    case node['platform']
    when 'amazon', 'fedora'
      include_recipe 'enterprise::runit_upstart'
    else
      if node['platform_version'] =~ /^6/
        include_recipe 'enterprise::runit_upstart'
      end
    end
  end
end

component_runit_supervisor node['enterprise']['name'] do
  install_path node[node['enterprise']['name']]['install_path']
  ctl_name node[node['enterprise']['name']]['ctl_name']
end
