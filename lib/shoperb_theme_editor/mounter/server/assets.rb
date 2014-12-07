module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Assets

        def self.registered(app)
          app.get "assets/*" do |path|
            env_sprockets = request.env.dup
            env_sprockets['PATH_INFO'] = path
            Sprockets::Serve.all.call(env_sprockets)
          end

        end

      end
    end
  end
end end end
