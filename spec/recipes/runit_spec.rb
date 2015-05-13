require 'spec_helper'

RSpec.shared_examples "systemd create" do
  it "renders the unit template" do
    expect(chef_run).to create_template(
      "/usr/lib/systemd/system/#{enterprise_name}-runsvdir-start.service"
    ).with(
      :owner => "root",
      :group => "root",
      :mode => "0644",
      :variables => {
        :install_path => "/opt/testproject",
        :project_name => enterprise_name,
      },
      :source => "runsvdir-start.service.erb",
    )
  end

  it "enables the service" do
    expect(chef_run).to enable_service("#{enterprise_name}-runsvdir-start.service").with(
      :provider => Chef::Provider::Service::Systemd
    )
  end

  it "starts the service" do
    expect(chef_run).to start_service("#{enterprise_name}-runsvdir-start.service").with(
      :provider => Chef::Provider::Service::Systemd
    )
  end
end

RSpec.shared_examples "sysvinit create" do
  before :each do
    stub_command(
      "grep 'SV:123456:respawn:/opt/testproject/embedded/bin/runsvdir-start' /etc/inittab"
    ).and_return false
  end

  describe "inittab" do
    it "echoes the svdir line to it" do
      expect(chef_run).to run_execute(
        "echo 'SV:123456:respawn:/opt/testproject/embedded/bin/runsvdir-start' >> /etc/inittab"
      )
    end

    it "notifies execute[init q]" do
      expect(chef_run.execute(
        "echo 'SV:123456:respawn:/opt/testproject/embedded/bin/runsvdir-start' >> /etc/inittab"
      )).to notify("execute[init q]").to(:run).immediately
    end
  end
end

RSpec.shared_examples "upstart create" do
  before :each do
    stub_command("initctl status opscode-runsvdir | grep start").and_return true
    stub_command("initctl status #{enterprise_name}-runsvdir | grep stop").and_return true
  end

  it "stops the previously named service" do
    expect(chef_run).to run_execute("initctl stop opscode-runsvdir").with(
      :retries => 30
    )
  end

  it "deletes /etc/init/opscode-runsvdir.conf" do
    expect(chef_run).to delete_file "/etc/init/opscode-runsvdir.conf"
  end

  it "renders the init template" do
    expect(chef_run).to create_template("/etc/init/#{enterprise_name}-runsvdir.conf").with(
      :owner => "root",
      :group => "root",
      :mode => "0644",
      :source => "init-runsvdir.erb",
      :variables => {
        :install_path => "/opt/#{enterprise_name}",
        :ctl_name => "#{enterprise_name}-ctl",
      }
    )
  end

  it "runs the status command" do
    expect(chef_run).to run_execute("initctl status #{enterprise_name}-runsvdir").with(
      :retries => 30,
    )
  end

  it "runs the start command" do
    expect(chef_run).to run_execute("initctl start #{enterprise_name}-runsvdir").with(
      :retries => 30,
    )
  end

  context "when the enterprise_name is private_chef" do
    let(:enterprise_name) { "private_chef" }

    before :each do
      stub_command("initctl status private-chef-runsvdir | grep stop").and_return true
      runner.node.set['private_chef']['install_path'] = "/opt/opscode"
    end

    it "renders the init template" do
      expect(chef_run).to create_template("/etc/init/private-chef-runsvdir.conf").with(
        :owner => "root",
        :group => "root",
        :mode => "0644",
        :source => "init-runsvdir.erb",
        :variables => {
          :install_path => "/opt/opscode",
          :ctl_name => "private-chef-ctl",
        }
      )
    end

    it "runs the status command" do
      expect(chef_run).to run_execute("initctl status private-chef-runsvdir").with(
        :retries => 30,
      )
    end

    it "runs the start command" do
      expect(chef_run).to run_execute("initctl start private-chef-runsvdir").with(
        :retries => 30,
      )
    end
  end
end

describe 'enterprise::runit' do
  let(:runner) do
    ChefSpec::SoloRunner.new :step_into => ["component_runit_supervisor"]
  end
  subject(:chef_run) { runner.converge(described_recipe) }
  let(:enterprise_name) { "testproject" }

  before :each do
    # Set the node project_name
    runner.node.set['enterprise']['name'] = enterprise_name
    runner.node.set['testproject']['install_path'] = '/opt/testproject'
  end

  describe "component_runit_supervisor resource" do
    describe "action :create" do
      context "when on Amazon Linux" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "amazon", :version => "2014.03",
                                   :step_into => ["component_runit_supervisor"]
        end

        it_behaves_like "upstart create"
      end

      context "when on Debian" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "debian", :version => "7.4",
                                   :step_into => ["component_runit_supervisor"]
        end

        it_behaves_like "upstart create"
      end

      context "when on Fedora" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "fedora", :version => "20",
                                   :step_into => ["component_runit_supervisor"]
        end

        it_behaves_like "upstart create"
      end

      context "when on RHEL 5" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "redhat", :version => "5.9",
                                   :step_into => ["component_runit_supervisor"]
        end

        it_behaves_like "sysvinit create"
      end

      context "when on RHEL 6" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "redhat", :version => "6.5",
                                   :step_into => ["component_runit_supervisor"]
        end

        it_behaves_like "upstart create"
      end

      context "when on RHEL 7 with systemd" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "redhat", :version => "7.0", :step_into => ["component_runit_supervisor"] do |node|
            node.default['init_package'] = "systemd"
          end
        end

        it_behaves_like "systemd create"
      end

      context "when on Ubuntu" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "ubuntu", :version => "12.04",
                                   :step_into => ["component_runit_supervisor"]
        end

        it_behaves_like "upstart create"
      end
    end
  end
end
