require "chef/provider/lwrp_base"

class Chef
  class Provider
    class ComponentRunitSupervisor
      class Sysvinit < Chef::Provider::LWRPBase
        provides :component_runit_supervisor, :platform_family => "rhel" do |node|
          node['platform_version'].to_i == 5
        end

        use_inline_resources

        def action_create
          svdir_line = "#{new_resource.init_id}:123456:respawn:#{new_resource.install_path}/embedded/bin/runsvdir-start"

          execute "echo '#{svdir_line}' >> /etc/inittab" do
            not_if "grep '#{svdir_line}' /etc/inittab"
            notifies :run, "execute[init q]", :immediately
          end

          execute "init q" do
            action :nothing
          end
        end

        def action_delete
          log "not yet implemented"
        end

        def whyrun_supported?
          true
        end
      end
    end
  end
end
