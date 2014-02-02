module Shoperb::Editor
  class Server

    # Set the timezone according to the settings of the site
    #
    class Timezone < Middleware

      def call(env)
        self.set_accessors(env)

        Time.use_zone(shop.try(:timezone) || 'UTC') do
          app.call(env)
        end
      end

    end
  end
end