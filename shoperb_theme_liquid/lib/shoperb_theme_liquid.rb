require "active_support/all"
autoload :ActionView, "action_view"
autoload :Liquid, "liquid"

# Context changes:
# Url filter, use @context.registers[:url_for] proc instead of @context.registers[:controller].url_for
# Asset filter, use @context.registers[:asset_url] proc instead of @context.registers[:theme].asset_url
# Translate filter, use @context.registers[:translate] proc instead of @context.registers[:theme].translations.translate
# Translate filter, use @context.registers[:locale] instead of ::Globalize.locale
# Remove direct reference to CollectionDrop, Kaminari::PaginatableArray & ::I18n in Paginate tag somehow


module Shoperb module Theme
  module Liquid
    def self.autoload_all mod, folder
      Gem.find_files("#{folder}/*.rb").map{|match|Pathname.new(match)}.each do |path|
        mod.autoload :"#{path.basename(".rb").to_s.camelize}", "#{folder}/#{path.basename(".rb")}"
      end
    end

    module Filter
      Liquid.autoload_all self, "filters"
    end

    module Tag
      Liquid.autoload_all self, "tags"
    end

    class Template < ::Liquid::Template
      def self.parse(source, options = {})
        if source.kind_of?(::Liquid::Template)
          source
        else
          template = Template.new
          template.parse(source, options)
          template
        end
      end
    end
  end
  Liquid::Template.register_filter Liquid::Filter::Url
  Liquid::Template.register_filter Liquid::Filter::Datum
  Liquid::Template.register_filter Liquid::Filter::Asset
  Liquid::Template.register_filter Liquid::Filter::Html
  Liquid::Template.register_filter Liquid::Filter::Translate
  Liquid::Template.register_tag "layout", Liquid::Tag::Layout
  Liquid::Template.register_tag "paginate", Liquid::Tag::Paginate
  Liquid::Template.register_tag "form", Liquid::Tag::Form
end end

