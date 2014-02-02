module Shoperb::Editor
  class Server

    # Sanitize the path from the previous middleware in order
    # to make it work for the renderer.
    #
    class Page < Middleware

      def call(env)
        self.set_accessors(env)

        self.set_page!(env)

        app.call(env)
      end

      protected

      def set_page!(env)
        env['editor.page'] = self.fetch_page
      end

      def fetch_page
        mounting_point.templates[path]
      end

    end

  end
end
