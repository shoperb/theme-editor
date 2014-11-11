Sprockets.autoload :Helpers, "sprockets-helpers"

module Shoperb
  module Mounter
    class Server
      module Assets

        def self.registered(app)
          app.get "#{Sprockets::Helpers.prefix}/*" do |path|
            env_sprockets = request.env.dup
            env_sprockets['PATH_INFO'] = path
            CustomSprockets::Serve.all.call(env_sprockets)
          end

        end

      end
    end
  end
end
