module Tilt
  class LiquidTemplate
    def evaluate scope, context, *args, &block
      @engine.render(context)
    end
  end
end
module Shoperb
  module Mounter
    class Server
      module Renderer

        module Helpers
          def respond(templates, locals={}, registers={}, &block)
            require "pry"
            registers.reverse_merge!(
              url_for: ->(*args) { ActionDispatch::Routing::UrlFor.method(:url_for)[*args] },
              asset_url: ->(url, *args) { "/assets/#{url}" },
              translate: Shoperb::Translate.method(:translate),
              locale: Shoperb::Translate.locale
            )
            locals = locals.reverse_merge(default_locals)
            registers = registers.reverse_merge({layout: "layout"})
            templates = [templates].flatten
            format = Sinatra::RespondWith::Format.new(self)
            if (template = template_name(templates))
              locals.merge!(template_name: template.to_s)
              file = template_path(template)
              result = process_file file, locals, registers
              unless (layout_name = registers[:layout].to_s).blank?
                result = process_file(template_path(layout_name, settings.layouts_directory), locals.merge(content_for_layout: result), registers)
              end
              halt result
            end
            format.finish(&block)
          end

          def process_file file, locals, registers
            file = Pathname.new(file)
            result = File.read(file).force_encoding("UTF-8").gsub("\xC2\xA0", " ")

            while (ext = file.extname.gsub(".", "")).to_sym != settings.destination_format
              file = Pathname.new(file.to_s.gsub(".#{ext}", ""))
              result = send(ext, result)
            end

            send(settings.destination_format, result, locals: ::Liquid::Context.new({}, locals, registers))
          end

          def template_path name, base=settings.templates_directory
            template_paths(name, base).first
          end

          def template_name names, base=settings.templates_directory
            names.detect { |name| template_paths(name, base).any? }
          end

          def template_paths name, base=settings.templates_directory
            Dir[base.to_s + "/" + name.to_s + ".#{settings.destination_format}" + "{#{settings.allowed_engines.map { |ext_name| ".#{ext_name}" }.join(",")},}"]
          end
        end

        def self.registered app

          Liquid::Template.error_mode = :strict

          app.register Sinatra::RespondWith
          app.helpers Helpers
          app.set :templates_directory, Proc.new { File.join(root, "templates") }
          app.set :layouts_directory, Proc.new { File.join(root, "layouts") }

          ::Liquid::Template.file_system = ::Liquid::LocalFileSystem.new(app.settings.templates_directory)

          app.set :destination_format, :liquid
          app.set :allowed_engines, [:haml]
        end

      end
    end
  end
end
