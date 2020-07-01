name 'enterprise'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs common libraries and resources for Chef server and add-ons'
version '0.15.3'

depends 'runit', '= 5.1.6'

source_url 'https://github.com/chef-cookbooks/enterprise-chef-common'
issues_url 'https://github.com/chef-cookbooks/enterprise-chef-common/issues'

chef_version '>= 13'

%w(redhat oracle centos scientific amazon debian ubuntu).each do |os|
  supports os
end
