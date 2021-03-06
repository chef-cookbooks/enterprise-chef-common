# service identifies redhat 6 as sysv, but we install under upstart
if service('sshd').type == 'sysv' && !(os['family'] == 'redhat' && os['release'].to_i == 6)
  describe command("ps x | grep 'runsvdir.*\/opt\/tp' | grep -v grep") do
    its(:exit_status) { should eq(1) }
  end

  describe file('/etc/inittab') do
    its(:content) { should_not match(%r{/opt/tp/embedded/bin/runsvdir-start}) }
  end
end
