require_relative './models/base.rb'
require_relative '../editor/models/singleton_base.rb'
require_relative '../editor/models/liquid_base.rb'
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |lib| require lib }