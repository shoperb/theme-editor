module Shoperb module Theme module Editor
  module Mounter

    Editor.autoload_all self, "mounter"

    module Model

      def self.console
        binding.pry
      end

      Editor.autoload_all self, "mounter/models"
    end

    module Drop
      Editor.autoload_all self, "mounter/drops"
    end

    def self.start
      Rack::Handler::WEBrick.run(Server.new,
        Port: Editor[:port],
        AccessLog: [],
        Logger: WEBrick::Log::new("/dev/null", 7),
        StartCallback: -> { Logger.success "Server started\n" }
      )
    end

  end
end end end
