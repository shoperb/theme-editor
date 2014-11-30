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

      module Abstract
        Shoperb.autoload_all self, "shoperb/mounter/models/abstract"
      end

      module Concerns
        Shoperb.autoload_all self, "shoperb/mounter/models/concerns"
      end

      Shoperb.autoload_all self, "shoperb/mounter/models"

    end

    module Drop

      Shoperb.autoload_all self, "shoperb/mounter/drops"

      class << self
        def const_missing_with_default *args
          const_missing_without_default(*args) rescue Delegate
        end
        alias_method_chain :const_missing, :default
      end
    end

  end
end
