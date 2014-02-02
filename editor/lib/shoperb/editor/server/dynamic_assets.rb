module Shoperb::Editor
  class Server

    class DynamicAssets < Middleware

      attr_reader :app, :sprockets, :regexp

      def initialize(app, site_path)
        super(app)
        @regexp     = /^\/app\/assets\/(.*)$/
        @sprockets  = Shoperb::Mounter::Extensions::Sprockets.environment(site_path)
      end

      def call(env)
        if env['PATH_INFO'] =~ self.regexp
          env['PATH_INFO'] = $1

          begin
            self.sprockets.call(env)
          rescue Exception => e
            raise Shoperb::Editor::DefaultException.new "Unable to serve a dynamic asset. Please check the logs.", e
          end
        else
          app.call(env)
        end
      end

    end

  end
end