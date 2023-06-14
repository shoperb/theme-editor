require 'artisans'

module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Assets

        def self.asset_wrapper app, root
          compiler = Editor.compiler(root, domain: Editor["oauth-site"], theme: Editor.handle, digests: false)
          app.get "#{root}*" do |path|
            env_sprockets = request.env.dup
            env_sprockets['PATH_INFO'] = path
            compiler.rack_response(env_sprockets)
          end
        end

        def self.registered(app)
          asset_wrapper app, "/system/assets/#{Editor["oauth-site"]}/#{Editor.handle}/"
          asset_wrapper app, "/system/assets/"

          app.get "/#{Editor["oauth-site"]}/images/*/*" do |id, filename|
            env_sprockets = request.env.dup
            env_sprockets['PATH_INFO'] = "images/#{filename}"
            Model::Image.find(id: id)
            ::Sprockets::Environment.new do |env|
              env.append_path "data/assets"
            end.call(env_sprockets)
          end

        end

      end
    end
  end
end end end
