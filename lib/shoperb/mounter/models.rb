require_relative './models/base.rb'
require_relative '../mounter/models/singleton_base.rb'
require_relative '../mounter/models/liquid_base.rb'
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |lib| require lib }