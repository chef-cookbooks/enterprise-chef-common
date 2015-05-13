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
          template "/usr/lib/systemd/system/#{unit_name}" do
            owner "root"
            group "root"
            mode "0644"
            variables({
              :install_path => new_resource.install_path,
              :project_name => new_resource.name,
            })
            source "runsvdir-start.service.erb"
          end

          service unit_name do
            action [:enable, :start]
            provider Chef::Provider::Service::Systemd
          end
        end

        def whyrun_supported?
          true
        end

        def unit_name
          "#{new_resource.name}-runsvdir-start.service"
        end
      end
    end
  end
end
