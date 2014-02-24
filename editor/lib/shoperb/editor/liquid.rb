require 'shoperb/mounter'
require 'liquid'

%w{. drops filters tags}.each do |dir|
  Dir[File.join(File.dirname(__FILE__), 'liquid', dir, '*.rb')].each { |lib| require lib }
end