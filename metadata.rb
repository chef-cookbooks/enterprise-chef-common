name 'enterprise'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs common libraries and resources for Chef server and add-ons'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.15.0'

depends 'runit', '= 5.0.1'

source_url 'https://github.com/chef-cookbooks/enterprise'
issues_url 'https://github.com/chef-cookbooks/enterprise/issues'

chef_version '>= 13'

%w(redhat oracle centos scientific amazon debian ubuntu).each do |os|
  supports os
end
