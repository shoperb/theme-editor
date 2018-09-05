module Shoperb module Theme module Editor
  module Mounter

    Editor.autoload_all self, "mounter"

    module Model

      def self.console
        binding.pry
      end

      Editor.autoload_all self, "mounter/models"
    end

    def self.start
      Rack::Handler::WEBrick.run(Server.new,
        Port: Editor["port"],
        AccessLog: [],
        Logger: WEBrick::Log::new(Os["/dev/null"], 7),
        StartCallback: -> {
           Logger.success "Server started\nBrowse http://0.0.0.0:#{Editor["port"]}\n"
        }
      )
    rescue Errno::EADDRINUSE => e
      Logger.error e.message
      exit!
    end

  end
end end end
