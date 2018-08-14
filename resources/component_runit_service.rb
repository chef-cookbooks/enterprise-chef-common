# A runit service wrapper for a chef component
#
# :package defines which part of the node attributes we should look in for configuration
# as it different for each add-on e.g. :package => 'reporting' or :package => 'pushy'
#
resource_name :component_runit_service

property :package, String, default: 'private_chef'
property :log_directory, String
property :svlogd_size, Integer
property :svlogd_num, Integer
property :ha, [TrueClass, FalseClass]
property :control, Array
property :runit_attributes, Hash, default: {}

action :enable do
  package = new_resource.package
  component = new_resource.name
  log_directory = new_resource.log_directory || node[package][component]['log_directory']

  # runit resources don't support reloading the log service as an action :(
  execute "restart_#{component}_log_service" do
    command "#{node['runit']['sv_bin']} restart #{node['runit']['sv_dir']}/#{component}/log"
    action :nothing
  end

  template "#{log_directory}/config" do
    source 'config.svlogd'
    cookbook 'enterprise'
    mode '0644'
    owner 'root'
    group 'root'
    notifies :run, "execute[restart_#{component}_log_service]"
    variables(
      svlogd_size: (new_resource.svlogd_size || node[package][component]['log_rotation']['file_maxbytes']),
      svlogd_num: (new_resource.svlogd_num || node[package][component]['log_rotation']['num_to_keep'])
    )
  end

  runit_service component do
    action :enable
    retries 20
    control new_resource.control if new_resource.control
    options(
      log_directory: log_directory
    )
    new_resource.runit_attributes.each do |attr_name, attr_value|
      send(attr_name.to_sym, attr_value)
    end
  end

  # The runit cookbook fixed an issue with the sv binary being symlinked to
  # the init.d on directory on Debian/Ubuntu which causes chef-server-ctl to get
  # angry when we attempt to start the service manually. This template preserves
  # the system environment PATH variable rather than hard-coding the value in the
  # init script.
  edit_resource!(:template, '/opt/opscode/init/rabbitmq') do
    source 'sv-rabbitmq-init.erb'
    cookbook 'private-chef'
    variables({
      :name => 'rabbitmq',
      :sv_bin => '/opt/opscode/embedded/bin/sv',
      :init_dir => '/opt/opscode/init/'
    })
    only_if { platform_family? 'debian' && component == 'rabbitmq' }
  end

  # Keepalive management
  #
  # Our keepalived setup knows which services it must manage by
  # looking for a 'keepalive_me' sentinel file in the service's
  # directory.
  if EnterpriseChef::Helpers.ha?(node)
    # We need special handling for the ha param, as it's a boolean and
    # could be false, so we explicitly check for nil?
    is_keepalive_service = if new_resource.ha.nil?
                             node[package][component]['ha']
                           else
                             new_resource.ha
                           end
    file "#{node['runit']['sv_dir']}/#{component}/keepalive_me" do
      action is_keepalive_service ? :create : :delete
    end

    file "#{node['runit']['sv_dir']}/#{component}/down" do
      action is_keepalive_service ? :create : :delete
    end
  end
end

action :down do
  log "stop runit_service[#{new_resource.name}]" do
    notifies :down, "runit_service[#{new_resource.name}]", :immediately
  end
end

action :restart do
  runit_service new_resource.name do
    action :restart
  end
end


