define :component_runit_service, :package => 'private_chef',
                                 :log_directory => nil,
                                 :svlogd_size => nil,
                                 :svlogd_num => nil,
                                 :ha => nil,
                                 :control => nil,
                                 :action => :enable do
  component = params[:name]
  log_directory = params[:log_directory] || node[package][component]['log_directory']

  template "#{log_directory}/config" do
    source "config.svlogd"
    cookbook "enterprise"
    mode "0644"
    owner "root"
    group "root"
    variables(
      :svlogd_size => ( params[:svlogd_size] || node[package][component]['log_rotation']['file_maxbytes']),
      :svlogd_num  => ( params[:svlogd_num] || node[package][component]['log_rotation']['num_to_keep'])
    )
  end

  runit_service component do
    action :enable
    retries 20
    control params[:control] if params[:control]
    options(
      :log_directory => log_directory
    )
  end

  if params[:action] == :down
    log "stop runit_service[#{component}]" do
      notifies :down, "runit_service[#{component}]", :immediately
    end
  end

  # Keepalive management
  #
  # Our keepalived setup knows which services it must manage by
  # looking for a 'keepalive_me' sentinel file in the service's
  # directory.
  if EnterpriseChef::Helpers.ha?(node)
    # We need special handling for the ha param, as it's a boolean and
    # could be false, so we explicitly check for nil?
    is_keepalive_service = if params[:ha].nil?
                             node[package][component]['ha']
                           else
                             params[:ha]
                           end
    file "#{node['runit']['sv_dir']}/#{component}/keepalive_me" do
      action is_keepalive_service ? :create : :delete
    end
  end

end
