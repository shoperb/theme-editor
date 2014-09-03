module Shoperb
  module Mounter
    module Model
      module Abstract
        class LiquidBase < OpenStruct

          class << self
            def method_missing(name, *args, &block)
              all
            end

            def all
              Dir[File.join(directory, matcher)].map { |path| new(path: path) }
            end

            def directory
              File.join(File.expand_path("templates"))
            end

            def render! name, locals, registers
              names = [name].flatten
              instance = nil
              found_name = nil
              names.each do |current_name|
                found_name = current_name
                instance ||= all.detect { |template| /[^_]#{current_name}.liquid.haml\z/ =~ template.path }
                instance ||= all.detect { |template| /[^_]#{current_name}.liquid\z/ =~ template.path }
              end
              raise Error.new("File not found: #{name}.liquid(.haml) in #{Utils.rel_path(directory)}") unless instance
              locals.merge!(template_name: found_name.to_s)
              instance.render!(locals.stringify_keys!, registers)
            end
          end

          def parse content=File.read(path)
            Liquid::Template.parse(content)
          end

          def parse_haml content=File.read(path)
            parse(Haml::Engine.new(content).render)
          end

          def render! locals, registers
            template = path.ends_with?(".haml") ? parse_haml : parse

            [template, template.render!(locals.stringify_keys!, :registers => registers)]
          rescue Exception => e
            raise(e.is_a?(Error) ? e :
              Error.new("'#{e.message}' in #{Utils.rel_path(path)}").tap do |fe|
                fe.set_backtrace e.backtrace
              end
            )
          end

        end
      end
    end
  end
end