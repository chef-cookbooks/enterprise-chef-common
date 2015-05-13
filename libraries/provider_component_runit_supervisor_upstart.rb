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
          log "not yet implemented"
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
