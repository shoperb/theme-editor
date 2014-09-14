Sinatra.autoload :AssetPipeline, "sinatra/asset_pipeline"

module Shoperb
  module Mounter
    class Server
      module Assets

        def self.registered(app)
          app.set :assets_prefix, %w(assets data/assets)
          app.register Sinatra::AssetPipeline
        end

      end
    end
  end
end