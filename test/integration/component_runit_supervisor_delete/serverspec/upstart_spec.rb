require "spec_helper"

if (os[:family] == "redhat" && os[:release].to_i < 7) ||
   os[:family] == "ubuntu"
  describe service("testproject-runsvdir") do
    it { should_not be_running }
  end
end
