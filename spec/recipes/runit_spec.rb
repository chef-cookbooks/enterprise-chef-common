require 'spec_helper'

RSpec.shared_examples "systemd create" do
  it "treats private_chef special"

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

RSpec.shared_examples "systemd delete" do
  it "treats private_chef special"

  it "behaves like systemd delete"
end

RSpec.shared_examples "sysvinit create" do
  before :each do
    stub_command(
      "grep 'SV:123456:respawn:/opt/testproject/embedded/bin/runsvdir-start' /etc/inittab"
    ).and_return false
  end

  it "treats private_chef special"

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

RSpec.shared_examples "sysvinit delete" do
  it "treats private_chef special"

  it "behaves like sysvinit delete"
end

RSpec.shared_examples "upstart create" do
  before :each do
    stub_command("initctl status opscode-runsvdir | grep start").and_return true
    stub_command("initctl status #{enterprise_name}-runsvdir | grep stop").and_return true
  end

  it "treats private_chef special"

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
end

RSpec.shared_examples "upstart delete" do
  it "treats private_chef special"

  it "behaves like upstart delete"
end


describe 'enterprise::runit' do
  let(:runner) { ChefSpec::SoloRunner.new }
  subject(:chef_run) { runner.converge(described_recipe) }
  let(:enterprise_name) { "testproject" }

  before :each do
    # Set the node project_name
    runner.node.set['enterprise']['name'] = enterprise_name
    runner.node.set['testproject']['install_path'] = '/opt/testproject'

    stub_command("grep 'SV:123456:respawn:/opt/testproject/embedded/bin/runsvdir-start' /etc/inittab")
  end

  context 'when on RHEL 5' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'redhat', version: '5.9') }

    it 'includes the runit_sysvinit recipe' do
      expect(chef_run).to include_recipe 'enterprise::runit_sysvinit'
    end
  end

  describe "component_runit_supervisor resource" do
    describe "action :create" do
      context "when on Amazon Linux" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "amazon", :version => "2014.03"
        end

        it_behaves_like "upstart create"
      end

      context "when on Debian" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "debian", :version => "7.4"
        end

        it_behaves_like "upstart create"
      end

      context "when on Fedora" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "fedora", :version => "20"
        end

        it_behaves_like "upstart create"
      end

      context "when on RHEL 5" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "redhat", :version => "5.9"
        end

        it_behaves_like "sysvinit create"
      end

      context "when on RHEL 6" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "redhat", :version => "6.5"
        end

        it_behaves_like "upstart create"
      end

      context "when on RHEL 7 with systemd" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "redhat", :version => "7.0" do |node|
            node.default['init_package'] = "systemd"
          end
        end

        it_behaves_like "systemd create"
      end

      context "when on Ubuntu" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "ubuntu", :version => "12.04"
        end

        it_behaves_like "upstart create"
      end
    end

    describe "action :delete" do
      context "when on Amazon Linux" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "amazon", :version => "2014.03"
        end

        it_behaves_like "upstart delete"
      end

      context "when on Debian" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "debian", :version => "7.4"
        end

        it_behaves_like "upstart delete"
      end

      context "when on Fedora" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "fedora", :version => "20"
        end

        it_behaves_like "upstart delete"
      end

      context "when on RHEL 5" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "redhat", :version => "5.9"
        end

        it_behaves_like "sysvinit delete"
      end

      context "when on RHEL 6" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "redhat", :version => "6.5"
        end

        it_behaves_like "upstart delete"
      end

      context "when on RHEL 7 with systemd" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "redhat", :version => "7.0" do |node|
            node.default['init_package'] = "systemd"
          end
        end

        it_behaves_like "systemd delete"
      end

      context "when on Ubuntu" do
        let(:runner) do
          ChefSpec::SoloRunner.new :platform => "ubuntu", :version => "12.04"
        end

        it_behaves_like "upstart delete"
      end
    end
  end
end
