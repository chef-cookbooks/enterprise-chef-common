require "chef/provider/lwrp_base"

class Chef
  class Provider
    class ComponentRunitSupervisor
      class Systemd < Chef::Provider::LWRPBase
        provides :component_runit_supervisor do |node|
          node['init_package'] == "systemd"
        end

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
