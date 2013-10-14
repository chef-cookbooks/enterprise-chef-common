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
      case node['private_chef']['topology']
      when 'standalone', 'manual'
        true
      when 'tier'
        node['private_chef']['role'] == 'backend'
      when 'ha'
        node_name = node['fqdn']
        !!(node['private_chef']['servers'][node_name]['bootstrap'])
      end
    end

    # Determine if the node is the master for data storage replication
    # purposes.
    #
    # This will return `true` if the node is any of the following:
    #
    #   * A stand-alone EC install
    #   * A tier-topology backend machine
    #   * An HA topology backend keepalived master machine
    #
    # Any other machine will get `false`.
    #
    # @param node [Chef::Node] node
    # @return [Boolean]
    def self.is_data_master?(node)

      topology = node['private_chef']['topology']
      role = node['private_chef']['role']

      case topology
      when 'standalone'
        true # by definition
      when 'tier'
        role == 'backend'
      when 'ha'
        if (role == 'backend')
          dir = node['private_chef']['keepalived']['dir']
          cluster_status_file = "#{dir}/current_cluster_status"

          if File.exists?(cluster_status_file)
            File.open(cluster_status_file).read.chomp == 'master'
          else
            # If the file doesn't exist, then we are most likely doing
            # the initial setup, because keepalived must be configured
            # after everything else.  In this case, we'll consider
            # ourself the master if we're defined as the bootstrap
            # server
            is_bootstrap_server?(node)
          end
        else
          false # frontends can't be masters, by definition
        end
      end
    end
  end
end
