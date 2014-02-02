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
      ::Theme = Theme
    end
  end
end

