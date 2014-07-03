module Shoperb
  module Mounter
    module Models
      class Layout < LiquidBase
        def self.matcher
          "../layouts/*.liquid"
        end
      end
    end
  end
end

