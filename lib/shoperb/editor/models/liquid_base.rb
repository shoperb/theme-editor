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

      end
    end
  end
end