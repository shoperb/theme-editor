module Shoperb
  module Mounter
    module Liquid

      Shoperb.autoload_all self, "shoperb/mounter/liquid"


      module Drop
        Shoperb.autoload_all self, "shoperb/mounter/liquid/drops"
      end

      module Filter
        Shoperb.autoload_all self, "shoperb/mounter/liquid/filters"
      end

      module Tag
        Shoperb.autoload_all self, "shoperb/mounter/liquid/tags"
      end

      ::Liquid::Template.register_filter Filter::Url
      ::Liquid::Template.register_filter Filter::Datum
      ::Liquid::Template.register_filter Filter::Asset
      ::Liquid::Template.register_filter Filter::Html
      ::Liquid::Template.register_filter Filter::Standard
      ::Liquid::Template.register_filter Filter::Translate

      ::Liquid::Template.register_tag "layout", Tag::Layout
      ::Liquid::Template.register_tag "paginate", Tag::Paginate
      ::Liquid::Template.register_tag "form", Tag::Form

      ::Liquid::Template.file_system = EditorFileSystem.new

    end
  end
end