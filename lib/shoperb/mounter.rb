module Shoperb
  module Mounter
    extend self

    def start
      Rack::Handler::WEBrick.run(Server.new,
        Port: Shoperb[:port],
        AccessLog: [],
        Logger: WEBrick::Log::new("/dev/null", 7),
        StartCallback: -> { Logger.success "Server started\n" }
      )
    end

    Shoperb.autoload_all self, "shoperb/mounter"

    module Model

      def self.console
        binding.pry
      end

      Shoperb.autoload_all self, "shoperb/mounter/models"
    end

    module Drop

      # todo: TODOREF4
      Shoperb.autoload_all self, "shoperb/mounter/drops"

      class << self
        def const_missing_with_default *args
          const_missing_without_default(*args) rescue Delegate
        end
        alias_method_chain :const_missing, :default
      end
      # todo: TODOREF4 end
    end

    module Filter
      Shoperb.autoload_all self, "shoperb/mounter/filters"
    end

    module Tag
      Shoperb.autoload_all self, "shoperb/mounter/tags"
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

  end
end
