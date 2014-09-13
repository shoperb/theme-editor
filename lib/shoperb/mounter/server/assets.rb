Sinatra.autoload :AssetPipeline, "sinatra/asset_pipeline"

module Shoperb
  module Mounter
    class Server
      module Assets
        extend self

        def registered(app)
          app.set :assets_prefix, %w(assets data/assets)
          app.register Sinatra::AssetPipeline
        end

      end
    end
  end
end