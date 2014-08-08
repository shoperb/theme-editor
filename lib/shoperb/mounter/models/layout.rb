module Shoperb
  module Mounter
    module Model
      class Layout < Abstract::LiquidBase
        def self.matcher
          "../layouts/*.liquid"
        end
      end
    end
  end
end

