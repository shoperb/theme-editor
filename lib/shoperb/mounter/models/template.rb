module Shoperb
  module Mounter
    module Model
      class Template < Abstract::LiquidBase

        def self.matcher
          "[^_]*.{liquid,liquid.haml}"
        end

        def self.ordered_and_named_matchers name
          [/[^_]#{name}.liquid.haml\z/, /[^_]#{name}.liquid\z/]
        end

      end
    end
  end
end

