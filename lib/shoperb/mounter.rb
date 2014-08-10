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

  end
end
