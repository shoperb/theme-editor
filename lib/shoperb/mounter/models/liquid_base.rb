module Shoperb
  module Mounter
    module Models
      class LiquidBase < OpenStruct

        class << self
          def method_missing(name, *args, &block)
            all
          end

          def all
            Dir[File.join(directory, matcher)].map { |path| new(path: path) }
          end

          def directory
            File.join(File.expand_path('templates'))
          end

          def render! name, locals, registers
            path = all.detect { |template| /[^_]#{name}.liquid\z/ =~ template.path }
            raise "File not found: #{name}.liquid in #{directory}" unless path
            path.render!(locals.stringify_keys!, registers)
          end
        end

        def parse
          ::Liquid::Template.parse(File.read(path))
        end

        def render! locals, registers
          template = parse

          [template, template.render!(locals.stringify_keys!, :registers => registers)]
        rescue Exception => e
          raise e, "'#{e.message}' in #{path}"
        end
      end
    end
  end
end