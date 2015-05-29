# NOTE:
#
# Uses the value of node[project_name]['postgresql']['username'] as
# the user to run the database-creation psql command

def whyrun_supported?
  true
end

use_inline_resources

action :create do

  project_name = node['enterprise']['name']
  connection_string = "--host #{new_resource.host} --username #{new_resource.username} --password #{new_resource.password}" unless node[project_name]['postgresql']['enable']

  execute "create_database_#{new_resource.database}" do
    command createdb_command
    user node[project_name]['postgresql']['username']
    not_if {database_exist?}
    retries 30
  end
end

def createdb_command
  cmd = ["createdb"]
  cmd << "--template #{new_resource.template}"
  cmd << "--encoding #{new_resource.encoding}"
  cmd << "--owner #{new_resource.owner}" if new_resource.owner
  cmd << "#{connection_string}" unless node[project_name]['postgresql']['enable']
  cmd << new_resource.database
  cmd.join(" ")
end

def database_exist?
  project_name = node['enterprise']['name']
  command = <<-EOM.gsub(/\s+/," ").strip!
    psql --dbname template1
         #{connection_string unless node[project_name]['postgresql']['enable']}
         --tuples-only
         --command "SELECT datname FROM pg_database WHERE datname='#{new_resource.database}';"
    | grep #{new_resource.database}
  EOM

  s = Mixlib::ShellOut.new(command,
                           :user => node[project_name]['postgresql']['username'])
  s.run_command
  s.exitstatus == 0
end
