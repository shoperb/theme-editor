require 'shoperb/mounter'
require 'liquid'

%w{. drops}.each do |dir|
  Dir[File.join(File.dirname(__FILE__), 'liquid', dir, '*.rb')].each { |lib| require lib }
end

Dir[File.join(File.dirname(__FILE__), 'liquid', 'tags', '*.rb')].each { |lib|
  require lib
  tag_name = lib.split("/")[-1].gsub('.rb','')
  Liquid::Template.register_tag tag_name, [lib.split("/")[-3], tag_name].join('/').classify.constantize
}


Dir[File.join(File.dirname(__FILE__), 'liquid', 'filters', '*.rb')].each { |lib|
  require lib
  ::Liquid::Template.register_filter lib.split("/").last.gsub(".rb",'').camelize.constantize
}