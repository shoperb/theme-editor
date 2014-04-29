require 'liquid'

%w{. drops tags filters}.each do |dir|
  Dir[File.join(File.dirname(__FILE__), 'liquid', dir, '*.rb')].each { |lib| require lib }
end

Liquid::Template.register_filter UrlFilters
Liquid::Template.register_filter DataFilters
Liquid::Template.register_filter AssetFilters
Liquid::Template.register_filter HtmlFilters
Liquid::Template.register_filter TranslateFilter

Liquid::Template.register_tag 'layout', Liquid::Layout
Liquid::Template.register_tag 'paginate', Liquid::Paginate
Liquid::Template.register_tag 'form', Liquid::Form