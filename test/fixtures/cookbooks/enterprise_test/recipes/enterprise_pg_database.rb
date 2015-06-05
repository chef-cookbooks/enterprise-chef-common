node.default['enterprise']['name'] = "testproject"

enterprise_pg_database node['test']['database'] do
  encoding node['test']['encoding']
  host node['test']['host']
  owner node['test']['owner']
  password node['test']['password']
  username node['test']['username']
  template node['test']['template']
end
