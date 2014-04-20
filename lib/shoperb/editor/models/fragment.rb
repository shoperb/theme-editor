module Shoperb
  module Editor
    module Models
      class Fragment < LiquidBase
        def self.matcher
          '_*.liquid'
        end

        def render! context
          parse.render!(context)
        end

        def self.render! name, context
          all.detect { |template| /_#{name}.liquid\z/ =~ template.path }.
              render!(context)
        end
      end
    end
  end
end

