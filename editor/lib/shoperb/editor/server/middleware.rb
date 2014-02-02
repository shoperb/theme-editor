module Shoperb::Editor
  class Server

    class Middleware

      attr_accessor :app, :request, :path, :liquid_assigns

      attr_accessor :mounting_point, :page, :content_entry

      def initialize(app = nil)
        @app = app
      end

      def call(env)
        app.call(env)
      end

      protected

      def set_accessors(env)
        self.path           = env['editor.path']
        self.request        = Rack::Request.new(env)
        self.mounting_point = env['editor.mounting_point']
        self.page           = env['editor.page']
        self.content_entry  = env['editor.content_entry']

        env['editor.liquid_assigns'] ||= {}
        self.liquid_assigns = env['editor.liquid_assigns']
      end

      def theme
        self.mounting_point.theme
      end

      def shop
        self.mounting_point.shop
      end

      def cart
        self.mounting_point.cart
      end

      def params
        self.request.params.deep_symbolize_keys
      end

      def html?
        ['text/html', 'application/x-www-form-urlencoded'].include?(self.request.media_type) &&
        !self.request.xhr? &&
        !self.json?
      end

      def json?
        self.request.content_type == 'application/json' || File.extname(self.request.path) == '.json'
      end

      def redirect_to(location, type = 301)
        self.log "Redirected to #{location}"
        [type, { 'Content-Type' => 'text/html', 'Location' => location }, []]
      end

      def log(msg)
        Shoperb::Editor::Logger.info msg
      end

    end

  end
end