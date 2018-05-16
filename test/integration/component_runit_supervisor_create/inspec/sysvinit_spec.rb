if service('sshd').type == 'sysv' &&
   # service identifies redhat 6 as sysv, but we install under upstart
   !(os['family'] == 'redhat' && os['release'].to_i == 6)
  describe command("pgrep -f 'runsvdir.*\/opt\/tp'") do
    its(:exit_status) { should eq(0) }
  end

  describe file('/etc/inittab') do
    its(:content) { should match(/\/opt\/tp\/embedded\/bin\/runsvdir-start/) }
  end
end
