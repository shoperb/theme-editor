require 'shoperb/mounter'
require 'liquid'

%w{. drops tags}.each do |dir|
  Dir[File.join(File.dirname(__FILE__), 'liquid', dir, '*.rb')].each { |lib| require lib }
end

Dir[File.join(File.dirname(__FILE__), 'liquid', 'filters', '*.rb')].each { |lib|
  require lib
  ::Liquid::Template.register_filter lib.split("/").last.gsub(".rb",'').camelize.constantize
}