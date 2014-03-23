module Shoperb
  module Editor
    module Assets
      def self.registered(app)
        app.register Sinatra::AssetPipeline
      end
    end
  end
end