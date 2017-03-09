require 'spec_helper'

if (os[:family] == 'redhat' && os[:release].to_i == 6) ||
   (os[:family] == 'ubuntu' && os[:release] != '16.04')
  describe command('initctl status testproject-runsvdir') do
    its(:stdout) { should match(/start\/running/) }
  end
end
