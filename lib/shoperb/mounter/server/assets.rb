Sinatra.autoload :AssetPipeline, "sinatra/asset_pipeline"

module Shoperb
  module Mounter
    class Server
      module Assets
        extend self

        def registered(app)
          app.register Sinatra::AssetPipeline
          app.set :assets_path, -> { File.join("assets") }
        end

      end
    end
  end
end