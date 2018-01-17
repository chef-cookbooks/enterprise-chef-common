# Initialize a PostgreSQL database cluster.  Ensures the data
# directory exists, runs initdb, and sets up postgresql.conf and
# pg_hba.conf files.
#
# Does NOT signal for the cluster to start; that's your responsibility
# if you want it.

# NOTE:
#
# Uses the value of node[project_name]['postgresql']['username'] as
# the user to run the initdb command.  This user will also be the
# owner of the data directory and configuration files.
#
# Additionally, the node[project_name]['postgresql'] hash is used
# for configuration file template creation.

property :data_dir, String, name_property: true
property :encoding, String, default: 'SQL_ASCII'

action :init do
  project_name = node['enterprise']['name']

  # Ensure the data directory exists first!
  directory new_resource.data_dir do
    owner node[project_name]['postgresql']['username']
    mode '0700'
    recursive true
  end

  # Initialize the cluster
  execute "initialize_cluster_#{new_resource.data_dir}" do
    command "initdb --pgdata #{new_resource.data_dir} --locale C --encoding #{new_resource.encoding}"
    user node[project_name]['postgresql']['username']
    not_if { ::File.exist?(::File.join(new_resource.data_dir, 'PG_VERSION')) }
  end

  # Create configuration files
  ['postgresql.conf', 'pg_hba.conf'].each do |config_file|
    template ::File.join(new_resource.data_dir, config_file) do
      owner node[project_name]['postgresql']['username']
      mode '0644'
      variables(node[project_name]['postgresql'].to_hash)
    end
  end
end
