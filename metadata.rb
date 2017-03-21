name 'enterprise'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs common libraries and resources for Chef server and add-ons'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.10.3'

depends 'runit', '> 1.6.0'

source_url 'https://github.com/chef-cookbooks/enterprise' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/enterprise/issues' if respond_to?(:issues_url)
