include ComponentRunitSupervisorResourceMixin

provides :component_runit_supervisor, platform_family: 'rhel' do |node|
  node['platform_version'].to_i == 6
end
provides :component_runit_supervisor, platform: 'fedora' do |node|
  node['platform_version'].to_i <= 14
end
provides :component_runit_supervisor,
         platform: %w(amazon ubuntu)

action :create do
  # Ensure the previous named iteration of the system job is nuked
  execute 'initctl stop opscode-runsvdir' do
    only_if 'initctl status opscode-runsvdir | grep start'
    retries 30
  end

  file '/etc/init/opscode-runsvdir.conf' do
    action :delete
  end

  template "/etc/init/#{project_name}-runsvdir.conf" do
    cookbook 'enterprise'
    owner 'root'
    group 'root'
    mode '0644'
    variables install_path: new_resource.install_path
    source 'init-runsvdir.erb'
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
end

action :delete do
  service "#{project_name}-runsvdir" do
    provider Chef::Provider::Service::Upstart
    action [:stop, :disable]
  end

  file "/etc/init/#{project_name}-runsvdir.conf" do
    action :delete
  end
end

action_class do
  # We have a special case for "private_chef"
  def ctl_name
    new_resource.name == 'private_chef' ? 'private-chef-ctl' : new_resource.ctl_name
  end

  def project_name
    new_resource.name == 'private_chef' ? 'private-chef' : new_resource.name
  end
end
