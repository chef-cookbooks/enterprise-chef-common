require "spec_helper"

if (os[:family] == "redhat" && os[:release].to_i == 6) ||
   os[:family] == "ubuntu"
  describe command("initctl status testproject-runsvdir") do
    its(:stdout) { should match(/start\/running/) }
  end
end
