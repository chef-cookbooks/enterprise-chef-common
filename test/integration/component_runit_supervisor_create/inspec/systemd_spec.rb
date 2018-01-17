if (os[:family] == 'redhat' && os[:release].to_i == 7) ||
   (os[:family] == 'ubuntu' && os[:release] == '16.04')
  describe systemd_service('testproject-runsvdir-start.service') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
