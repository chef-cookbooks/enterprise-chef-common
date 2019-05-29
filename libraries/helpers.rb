module EnterpriseChef
  module Helpers
    # Determine if this machine should be considered the bootstrap
    # server, based on topology, role, and explicit bootstrap
    # designation.
    #
    # Note that, for HA systems, it is possible for the bootstrap
    # server to *not* be the backend master server, due to a failover.
    # This method only looks at attributes, and does not inspect the
    # state of the server in any way.
    #
    # @param [Chef::Node] node
    # @return [Boolean]
    def self.is_bootstrap_server?(node)
      project_name = node['enterprise']['name']
      case node[project_name]['topology']
      when 'standalone', 'manual'
        true
      when 'tier'
        node[project_name]['role'] == 'backend'
      when 'ha'
        node_name = node['fqdn']
        !!(node[project_name]['servers'][node_name]['bootstrap'])
      end
    end

    # Determine if the node is the master for data storage replication
    # purposes.
    #
    # This will return `true` if the node is any of the following:
    #
    #   * A stand-alone EC install
    #   * A tier-topology backend machine
    #
    # Any other machine will get `false`.
    #
    # @param node [Chef::Node] node
    # @return [Boolean]
    def self.is_data_master?(node)
      project_name = node['enterprise']['name']
      topology = node[project_name]['topology']
      role = node[project_name]['role']

      case topology
      when 'standalone'
        true # by definition
      when 'tier'
        role == 'backend'
      end
    end

    # Determine if the machine is set up for a standalone topology
    #
    # @param node [Chef::Node] node
    # @return [Boolean]
    def self.standalone?(node)
      project_name = node['enterprise']['name']
      node[project_name]['topology'] == 'standalone'
    end

    # Determine if the machine is set up for a tiered topology
    #
    # @param node [Chef::Node] node
    # @return [Boolean]
    def self.tier?(node)
      project_name = node['enterprise']['name']
      node[project_name]['topology'] == 'tier'
    end

    # Determine if the machine should be running backend services,
    # regardless of topology.
    #
    # @param node [Chef::Node] node
    # @return [Boolean]
    def self.backend?(node)
      project_name = node['enterprise']['name']
      standalone?(node) || node[project_name]['role'] == 'backend'
    end

    # Determine if the machine should be running frontend services,
    # regardless of topology.
    #
    # @param node [Chef::Node] node
    # @return [Boolean]
    def self.frontend?(node)
      project_name = node['enterprise']['name']
      standalone?(node) || node[project_name]['role'] == 'frontend'
    end
  end
end
