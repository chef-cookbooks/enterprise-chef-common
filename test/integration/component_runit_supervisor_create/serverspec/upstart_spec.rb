require 'spec_helper'

if (os[:family] == 'redhat' && os[:release].to_i == 6) ||
   (os[:family] == 'ubuntu' && os[:release] != '16.04')
  describe command('initctl status testproject-runsvdir') do
    its(:stdout) { should match(/start\/running/) }
  end

  describe file('/etc/init/testproject-runsvdir.conf') do
    # Increases the kill timeout from 5 seconds
    its(:content) { is_expected.to match(/kill timeout/) }
    # Sends SIGKILL to timed out runsv's
    its(:content) { is_expected.to match(/sv force-stop/) }
    # Shuts down on reboots
    its(:content) { is_expected.to match(/stop on runlevel \[016\]/) }
  end
end
