actions :create

default_action :create

attribute :username,
:kind_of => String,
:name_attribute => true

attribute :password,
:kind_of => String,
:required => true

attribute :superuser,
:kind_of => [TrueClass, FalseClass],
:default => false

attribute :admin_username,
:kind_of => String,
:required => false

attribute :admin_password,
:kind_of => String,
:required => false

attribute :host,
:kind_of => String,
:required => false
