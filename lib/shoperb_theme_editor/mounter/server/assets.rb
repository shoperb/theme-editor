require_relative "../../../../shoperb_theme_sprockets/lib/shoperb_theme_sprockets"

module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Assets

        def self.registered(app)
          app.get "/system/assets/*" do |path|
            env_sprockets = request.env.dup
            env_sprockets['PATH_INFO'] = "#{path}"
            Shoperb::Theme::Sprockets::Environment.new do |env|
              env.append_path "assets"
              env.append_path "data/assets/images"
            end.call(env_sprockets)
          end
          app.get "/#{Model::Shop.first.domain}/images/*/*" do |id, filename|
            env_sprockets = request.env.dup
            env_sprockets['PATH_INFO'] = "images/#{filename}"
            Model::Image.find id
            Shoperb::Theme::Sprockets::Environment.new do |env|
              env.append_path "data/assets"
            end.call(env_sprockets)
          end

        end

      end
    end
  end
end end end
