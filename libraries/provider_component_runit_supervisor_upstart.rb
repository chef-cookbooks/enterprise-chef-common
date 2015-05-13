require "chef/provider/lwrp_base"

class Chef
  class Provider
    class ComponentRunitSupervisor
      class Upstart < Chef::Provider::LWRPBase
        provides :component_runit_supervisor, :platform_family => "debian"
        provides :component_runit_supervisor, :platform_family => "rhel" do |node|
          node['platform_version'] =~ /^6/
        end
        provides :component_runit_supervisor, :platform => "amazon"
        provides :component_runit_supervisor, :platform => "fedora"

        use_inline_resources

        def action_create
          # Ensure the previous named iteration of the system job is nuked
          execute "initctl stop opscode-runsvdir" do
            only_if "initctl status opscode-runsvdir | grep start"
            retries 30
          end

          file "/etc/init/opscode-runsvdir.conf" do
            action :delete
          end

          template "/etc/init/#{project_name}-runsvdir.conf" do
            owner "root"
            group "root"
            mode "0644"
            variables({
              :install_path => new_resource.install_path,
              :ctl_name => ctl_name,
            })
            source "init-runsvdir.erb"
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

        def action_delete
          log "not yet implemented"
        end

        def whyrun_supported?
          true
        end

        # We have a special case for "private_chef"
        def ctl_name
          new_resource.name == "private_chef" ? "private-chef-ctl" : new_resource.ctl_name
        end

        def project_name
          new_resource.name == "private_chef" ? "private-chef" : new_resource.name
        end
      end
    end
  end
end
