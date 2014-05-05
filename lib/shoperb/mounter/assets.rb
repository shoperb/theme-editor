module Shoperb
  module Mounter
    module Assets
      def self.registered(app)
        app.register Sinatra::AssetPipeline
        app.set :assets_path, -> { File.join("assets") }
      end
    end
  end
end