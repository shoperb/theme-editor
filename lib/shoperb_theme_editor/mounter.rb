module Shoperb module Theme module Editor
  module Mounter
    extend self

    def start
      Rack::Handler::WEBrick.run(Server.new,
        Port: Editor[:port],
        AccessLog: [],
        Logger: WEBrick::Log::new("/dev/null", 7),
        StartCallback: -> { Logger.success "Server started\n" }
      )
    end

    Editor.autoload_all self, "shoperb_theme_editor/mounter"

    module Model

      module Abstract
        Editor.autoload_all self, "shoperb_theme_editor/mounter/models/abstract"
      end

      module Concerns
        Editor.autoload_all self, "shoperb_theme_editor/mounter/models/concerns"
      end

      Editor.autoload_all self, "shoperb_theme_editor/mounter/models"

    end

    module Drop

      Editor.autoload_all self, "shoperb_theme_editor/mounter/drops"

      class << self
        def const_missing_with_default *args
          const_missing_without_default(*args) rescue Delegate
        end
        alias_method_chain :const_missing, :default
      end
    end

  end
end end end
