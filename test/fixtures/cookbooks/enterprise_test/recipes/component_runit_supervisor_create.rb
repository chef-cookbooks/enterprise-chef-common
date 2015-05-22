component_runit_supervisor node['enterprise']['name'] do
  ctl_name "a-ctl-name-for-testproject"
  sysvinit_id "TP"
  install_path "/opt/tp"
  action :create
end
