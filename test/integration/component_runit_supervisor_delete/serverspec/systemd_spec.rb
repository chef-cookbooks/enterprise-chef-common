require "spec_helper"

if os[:family] == "redhat" && os[:release].to_i == 7
  describe service("testproject-runsvdir-start.service") do
    it { should_not be_running }
  end
end
