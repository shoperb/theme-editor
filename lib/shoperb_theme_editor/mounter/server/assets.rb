require_relative "../../../../artisans/lib/artisans"

module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Assets

        def self.asset_wrapper app, root
          compiler = Editor.compiler(root, domain: Model::Shop.first.domain, theme: Editor.handle)
          app.get "#{root}*" do |path|
            env_sprockets = request.env.dup
            env_sprockets['PATH_INFO'] = path
            compiler.rack_response(env_sprockets)
          end
        end

        def self.registered(app)
          raise Error.new("Shop model required") unless Model::Shop.first

          asset_wrapper app, "/system/assets/#{Model::Shop.first.domain}/#{Editor.handle}/"
          asset_wrapper app, "/system/assets/"

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
