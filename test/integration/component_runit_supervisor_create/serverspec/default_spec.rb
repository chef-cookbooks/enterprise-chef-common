require "spec_helper"

# Child processes of runsvdir
["runsv a", "runsv b", "yes", "yes n"].each do |p|
  describe process(p) do
    it { should be_running }
  end
end
