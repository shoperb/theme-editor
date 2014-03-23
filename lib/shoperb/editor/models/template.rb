module Shoperb
  module Editor
    module Models
      class Template < LiquidBase

        def self.matcher
          '[^_]*.liquid'
        end

      end
    end
  end
end

