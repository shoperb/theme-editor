module Shoperb
  module Mounter
    module Model
      class Template < Abstract::LiquidBase

        def self.matcher
          "[^_]*.{liquid,liquid.haml}"
        end

      end
    end
  end
end

