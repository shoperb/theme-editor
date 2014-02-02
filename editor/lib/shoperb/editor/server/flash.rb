module Shoperb::Editor
  class Server

    class Flash < Middleware

      def call(env)


        app.call(env)
      end

    end

  end
end