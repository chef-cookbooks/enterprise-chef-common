node.default['enterprise']['name'] = "testproject"

enterprise_pg_user "testuser" do
  admin_password node['test']['admin_password']
  admin_username node['test']['admin_username']
  host node['test']['host']
  password node['test']['password']
  superuser node['test']['superuser']
end
