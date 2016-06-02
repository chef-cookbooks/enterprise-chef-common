require "spec_helper"

if (os[:family] == "redhat" && os[:release].to_i == 7) ||
   (os[:family] == "ubuntu" && os[:release] == "16.04")
  describe service("testproject-runsvdir-start.service") do
    it { should be_running.under('systemd') }
  end
end
