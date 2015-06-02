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
  connection_string = []
  connection_string << "--host #{new_resource.host} " if  new_resource.host
  connection_string << "--username #{new_resource.username} " if  new_resource.username
  connection_string << "--password #{new_resource.password} " if  new_resource.password
  connection_string = connection_string.join(" ")

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
  cmd << "#{connection_string}" unless connection_string.empty?
  cmd << new_resource.database
  cmd.join(" ")
end

def database_exist?
  project_name = node['enterprise']['name']
  connection_string = []
  connection_string << "--host #{new_resource.host} " if  new_resource.host
  connection_string << "--username #{new_resource.username} " if  new_resource.username
  connection_string << "--password #{new_resource.password} " if  new_resource.password
  connection_string = connection_string.join(" ")

  command = <<-EOM.gsub(/\s+/," ").strip!
    psql --dbname template1
         #{connection_string unless connection_string.empty?}
         --tuples-only
         --command "SELECT datname FROM pg_database WHERE datname='#{new_resource.database}';"
    | grep #{new_resource.database}
  EOM

  s = Mixlib::ShellOut.new(command,
                           :user => node[project_name]['postgresql']['username'])
  s.run_command
  s.exitstatus == 0
end
