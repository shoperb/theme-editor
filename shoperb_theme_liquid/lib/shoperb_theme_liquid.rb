require "active_support/all"
require "liquid"
autoload :ActionView, "action_view"

# Context changes:
# Asset filter, use @context.registers[:asset_url] proc instead of @context.registers[:theme].asset_url
# Translate filter, use @context.registers[:translate] proc instead of @context.registers[:theme].translations.translate
# Translate filter, use @context.registers[:locale] instead of ::Globalize.locale

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
        if source.kind_of?(self)
          source
        else
          template = new
          template.parse(source, options)
          template
        end
      end
    end
  end
  ::Liquid::Template.register_filter Liquid::Filter::Url
  ::Liquid::Template.register_filter Liquid::Filter::Datum
  ::Liquid::Template.register_filter Liquid::Filter::Asset
  ::Liquid::Template.register_filter Liquid::Filter::Html
  ::Liquid::Template.register_filter Liquid::Filter::Translate
  ::Liquid::Template.register_tag "layout", Liquid::Tag::Layout
  ::Liquid::Template.register_tag "paginate", Liquid::Tag::Paginate
  ::Liquid::Template.register_tag "form", Liquid::Tag::Form
  ::Liquid::Template.register_tag "include", Liquid::Tag::Include
end end
