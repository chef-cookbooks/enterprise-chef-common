actions :init

default_action :init

attribute :data_dir,
kind_of: String,
name_attribute: true

attribute :encoding,
kind_of: String,
default: 'SQL_ASCII'
