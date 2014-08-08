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

      Template.register_filter Filter::Url
      Template.register_filter Filter::Datum
      Template.register_filter Filter::Asset
      Template.register_filter Filter::Html
      Template.register_filter Filter::Standard
      Template.register_filter Filter::Translate

      Template.register_tag "layout", Tag::Layout
      Template.register_tag "paginate", Tag::Paginate
      Template.register_tag "form", Tag::Form

      Template.file_system = EditorFileSystem.new

    end
  end
end