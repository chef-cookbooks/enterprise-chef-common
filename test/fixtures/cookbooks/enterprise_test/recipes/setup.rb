# Include system-wide runit
include_recipe "runit"

# Fake ctl command
file "/usr/bin/testproject-ctl" do
  mode "0755"
  content "#!/bin/sh\nfor file in /opt/tp/service/*; do /opt/tp/embedded/bin/sv stop $file; done"
end

# Create directories and example services for our project. In real life an
# omnibus installer would do this
directory "/opt/tp/embedded/bin" do
  recursive true
end

directory "/opt/tp/service/a" do
  recursive true
end

directory "/opt/tp/service/b" do
  recursive true
end

file "/opt/tp/service/a/run" do
  mode "0755"
  content "#!/bin/sh\nexec yes"
end

file "/opt/tp/service/b/run" do
  mode "0755"
  content "#!/bin/sh\nexec yes n"
end

# Symlink the runit binaries we need into our directory. In real life these
# would have been installed in the directory above
%w[ runsv runsvdir sv ].each do |bin|
  link "/opt/tp/embedded/bin/#{bin}" do
    to "#{File.dirname(node['runit']['sv_bin'])}/#{bin}"
  end
end

template "/opt/tp/embedded/bin/runsvdir-start" do
  mode "0755"
  source "runsvdir-start.erb"
end
