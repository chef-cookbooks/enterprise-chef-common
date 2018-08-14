name 'enterprise'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs common libraries and resources for Chef server and add-ons'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.15.0'

depends 'runit', '> 1.6.0'

source_url 'https://github.com/chef-cookbooks/enterprise'
issues_url 'https://github.com/chef-cookbooks/enterprise/issues'

chef_version '>= 12.7' if respond_to?(:chef_version)

%w(redhat oracle centos scientific fedora amazon debian ubuntu).each do |os|
  supports os
end
