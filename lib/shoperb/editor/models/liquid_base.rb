module Shoperb
  module Editor
    module Models
      class LiquidBase < OpenStruct

        def self.method_missing(name, *args, &block)
          self.all
        end

        def self.all
          Dir[File.join(File.expand_path('templates'), matcher)].map { |path| new(path: path) }
        end

        def parse
          ::Liquid::Template.parse(File.read(path))
        end

        def render! locals, registers
          template = parse

          [template, template.render!(locals.stringify_keys!, :registers => registers)]
        end

        def self.render! name, locals, registers
          all.detect { |template| /[^_]#{name}.liquid\z/ =~ template.path }.
            render!(locals.stringify_keys!, registers)
        end

      end
    end
  end
end