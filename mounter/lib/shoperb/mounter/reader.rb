require 'shoperb/mounter/reader/runner'
require 'shoperb/mounter/reader/file_system'
require 'shoperb/mounter/reader/file_system/base'
require 'shoperb/mounter/reader/file_system/singleton_base'
require 'shoperb/mounter/reader/file_system/plural_base'
require 'shoperb/mounter/reader/file_system/liquid_base'
Dir[File.join(File.dirname(__FILE__), 'reader', 'file_system', '*.rb')].each { |lib| require lib }

