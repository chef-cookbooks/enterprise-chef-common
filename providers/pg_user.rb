# NOTE:
#
# Uses the value of node[project_name]['postgresql']['username'] as
# the user to run the user-creation psql command

def whyrun_supported?
  true
end

use_inline_resources

action :create do
  project_name = node['enterprise']['name']

  execute "create_postgres_user_#{new_resource.username}" do
    command "psql --dbname template1 #{connection_string} --command \"#{create_user_query}\""
    user node[project_name]['postgresql']['username']
    not_if {user_exist?}
    retries 30
  end
end

def create_user_query
  @create_user_query ||= [].tap do |ary|
    ary << "CREATE USER #{new_resource.username} WITH"
    ary << "SUPERUSER" if new_resource.superuser
    ary << "ENCRYPTED PASSWORD '#{new_resource.password}';"
  end.join(" ")
end

def user_exist?
  project_name = node['enterprise']['name']
  command = <<-EOM.gsub(/\s+/," ").strip!
    psql --dbname template1
         #{connection_string}
         --tuples-only
         --command "SELECT rolname FROM pg_roles WHERE rolname='#{new_resource.username}';"
    | grep #{new_resource.username}
  EOM

  s = Mixlib::ShellOut.new(command,
                           :user => node[project_name]['postgresql']['username'])
  s.run_command
  s.exitstatus == 0
end

def connection_string
  @connection_string ||= [].tap do |ary|
    ary << "--host #{new_resource.host}" if  new_resource.host
    ary << "--username #{new_resource.admin_username}" if  new_resource.admin_username
    ary << "--password #{new_resource.admin_password}" if  new_resource.admin_password
  end.join(" ")
end
