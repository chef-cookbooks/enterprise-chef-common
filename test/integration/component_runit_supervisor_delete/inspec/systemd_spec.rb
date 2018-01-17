if os[:family] == 'redhat' && os[:release].to_i == 7
  describe systemd_service('testproject-runsvdir-start.service') do
    it { should_not be_installed }
    it { should_not be_enabled }
    it { should_not be_running }
  end
end
