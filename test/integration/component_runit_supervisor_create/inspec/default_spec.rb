s = service('sshd')

# Child processes of runsvdir
['runsv a', 'runsv b', 'yes', 'yes n'].each do |p|
  describe processes(p) do
    it { should exist }
  end
end
