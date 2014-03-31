require 'spec_helper'

describe 'enterprise::runit' do
  let(:runner) { ChefSpec::Runner.new }
  subject(:chef_run) { runner.converge(described_recipe) }

  before :each do
    # ChefSpec told me to do this
    stub_command("grep 'SV:123456:respawn:/opt/opscode/embedded/bin/runsvdir-start' /etc/inittab")
    stub_command('initctl status opscode-runsvdir | grep start')
    stub_command('initctl status private-chef-runsvdir | grep stop')
    stub_command('initctl status testproject-runsvdir | grep stop')
    stub_command("grep '\#{init_id}:123456:respawn:\#{install_path}/embedded/bin/runsvdir-start' /etc/inittab")

    # Set the node project_name
    runner.node.set['enterprise']['name'] = 'testproject'
    runner.node.set['testproject'] = {}
  end

  context 'when on Amazon Linux' do
    let(:runner) { ChefSpec::Runner.new(platform: 'amazon', version: '2014.03') }

    it 'includes the runit_upstart recipe' do
      expect(chef_run).to include_recipe 'enterprise::runit_upstart'
    end
  end

  context 'when on Debian' do
    let(:runner) { ChefSpec::Runner.new(platform: 'debian', version: '7.4') }

    it 'includes the runit_upstart recipe' do
      expect(chef_run).to include_recipe 'enterprise::runit_upstart'
    end
  end

  context 'when on Fedora do' do
    let(:runner) { ChefSpec::Runner.new(platform: 'fedora', version: '20') }

    it 'includes the runit_upstart recipe' do
      expect(chef_run).to include_recipe 'enterprise::runit_upstart'
    end
  end

  context 'when on RHEL 5' do
    let(:runner) { ChefSpec::Runner.new(platform: 'redhat', version: '5.9') }

    it 'includes the runit_sysvinit recipe' do
      expect(chef_run).to include_recipe 'enterprise::runit_sysvinit'
    end
  end

  context 'when on RHEL 6' do
    let(:runner) { ChefSpec::Runner.new(platform: 'redhat', version: '6.5') }

    it 'includes the runit_upstart recipe' do
      expect(chef_run).to include_recipe 'enterprise::runit_upstart'
    end
  end

  context 'when on Ubuntu' do
    let(:runner) { ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') }

    it 'includes the runit_upstart recipe' do
      expect(chef_run).to include_recipe 'enterprise::runit_upstart'
    end
  end

end
