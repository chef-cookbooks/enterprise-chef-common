if service('sshd').type == 'systemd'
  describe systemd_service('testproject-runsvdir-start.service') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/systemd/system/testproject-runsvdir-start.service') do
    if package('systemd').version.to_i >= 228
      its(:content) { is_expected.to match(/TasksMax/) }
    else
      its(:content) { is_expected.not_to match(/TasksMax/) }
    end
  end
end
