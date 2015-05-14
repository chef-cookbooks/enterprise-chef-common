require 'spec_helper'

describe 'enterprise::runit' do
  let(:runner) do
    ChefSpec::SoloRunner.new
  end
  subject(:chef_run) { runner.converge(described_recipe) }
  let(:enterprise_name) { "testproject" }

  before :each do
    # Set the node project_name
    runner.node.set['enterprise']['name'] = enterprise_name
    runner.node.set['testproject']['install_path'] = '/opt/testproject'
  end

  it "creates a component_runit_supervisor"
end
