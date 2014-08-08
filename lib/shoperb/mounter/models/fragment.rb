module Shoperb
  module Mounter
    module Model
      class Fragment < Abstract::LiquidBase

        def self.matcher
          "_*.liquid"
        end

        def render! context
          parse.render!(context)
        end

        def self.render! name, context
          instance = all.detect { |template| /_#{name}.liquid\z/ =~ template.path }
          raise Error.new("File not found: _#{name}.liquid in #{Utils.rel_path(directory)}") unless instance
          instance.render!(context)
        end

      end
    end
  end
end

