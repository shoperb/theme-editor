require 'shoperb/mounter'
require 'liquid'
require 'liquid/tags/assign'
require 'liquid/tags/include'
require 'liquid/tags/if'

%w{. drops filters tags}.each do |dir|
  Dir[File.join(File.dirname(__FILE__), 'liquid', dir, '*.rb')].each { |lib| require lib }
end