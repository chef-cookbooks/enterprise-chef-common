if service('sshd').type == 'upstart' ||
   # service identifies redhat 6 as sysv, but we install as upstart
   (os['family'] == 'redhat' && os['release'].to_i == 6)
  describe service('testproject-runsvdir') do
    it { should_not be_running }
  end
end
