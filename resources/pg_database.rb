actions :create

default_action :create

attribute :database,
:kind_of => String,
:name_attribute => true

attribute :owner,
:kind_of => String,
:required => false

attribute :template,
:kind_of => String,
:default => "template0"

attribute :encoding,
:kind_of => String,
:default => "UTF-8"

attribute :admin_username,
:kind_of => String,
:required => false

attribute :admin_password,
:kind_of => String,
:required => false

attribute :host,
:kind_of => String,
:required => false
