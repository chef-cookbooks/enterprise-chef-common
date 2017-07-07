property :database, String, name_property: true
property :owner, String
property :template, String, default: 'template0'
property :encoding, String, default: 'UTF-8'
property :username, String
property :password, String
property :host, String

# NOTE:
#
# Uses the value of node[project_name]['postgresql']['username'] as
# the user to run the database-creation psql command

action :create do
  parent = self
  project_name = node['enterprise']['name']

  ENV['PGHOST'] = parent.host if parent.host
  ENV['PGUSER'] = parent.username if parent.username
  ENV['PGPASSWORD'] = parent.password if parent.password

  execute "create_database_#{parent.database}" do
    command createdb_command
    user node[project_name]['postgresql']['username']
    not_if { database_exist? }
    retries 30
  end
end

action_class do
  def createdb_command
    [].tap do |cmd|
      cmd << 'createdb'
      cmd << "--template #{template}"
      cmd << "--encoding #{encoding}"
      cmd << "--owner #{owner}" if owner
      cmd << database
    end.join(' ')
  end

  def database_exist?
    project_name = node['enterprise']['name']

    cmd = []
    cmd << 'psql'
    cmd << '--dbname template1 --tuples-only'
    cmd << %(--command "SELECT datname FROM pg_database WHERE datname='#{database}';")
    cmd << "| grep #{database}"
    cmd = cmd.join(' ')

    s = Mixlib::ShellOut.new(cmd,
                             user: node[project_name]['postgresql']['username'])
    s.run_command
    s.exitstatus == 0
  end
end
