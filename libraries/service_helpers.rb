module EnterpriseChef
  module ServiceHelpers

    def self.should_notify?(service_name)
      File.symlink?("/opt/opscode/service/#{service_name}") && check_status(service_name)
    end

    def self.check_status(service_name)
      o = Mixlib::ShellOut.new("/opt/opscode/bin/private-chef-ctl status #{service_name}")
      o.run_command
      o.exitstatus == 0 ? true : false
    end

  end
end
