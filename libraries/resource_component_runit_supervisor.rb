require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class ComponentRunitSupervisor < Chef::Resource::LWRPBase
      self.resource_name = :component_runit_supervisor
      actions :create, :delete
      default_action :create

      attribute :name, kind_of: String, name_attribute: true, required: true
      attribute :ctl_name, kind_of: String, required: true
      attribute :sysvinit_id, kind_of: String, default: 'SV'
      attribute :install_path, kind_of: String, required: true
    end
  end
end
