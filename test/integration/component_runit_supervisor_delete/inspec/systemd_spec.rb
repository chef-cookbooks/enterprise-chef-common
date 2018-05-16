if service('sshd').type == 'systemd'
  describe systemd_service('testproject-runsvdir-start.service') do
    it { should_not be_installed }
    it { should_not be_enabled }
    it { should_not be_running }
  end
end
