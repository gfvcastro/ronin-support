require 'data_paths'

module Helpers
  include DataPaths

  TEMPLATE_DIR = File.expand_path(File.join(File.dirname(__FILE__),'data'))

  register_data_dir TEMPLATE_DIR
end
