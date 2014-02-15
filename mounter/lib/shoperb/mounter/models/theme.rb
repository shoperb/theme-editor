require "singleton"
module Shoperb
  module Mounter
    module Models
      class Theme < Base
        include Singleton

        def asset_url
          File.join('app','assets')
        end
      end
    end
  end
end

