component_runit_supervisor node['enterprise']['name'] do
  ctl_name 'testproject-ctl'
  install_path '/opt/tp'
  sysvinit_id 'TP'
  action :create
end
