module Shoperb
  module Mounter
    class Server
      module Renderer

        module Helpers
          def respond(templates, locals={}, registers={}, &block)
            locals = locals.reverse_merge(default_locals)
            registers = registers.reverse_merge({layout: "layout"})
            templates = [templates].flatten
            format = Sinatra::RespondWith::Format.new(self)
            files = find_templates(templates)
            if files.any?
              result = process_file files[0], locals, registers
              unless (layout_name = registers[:layout].to_s).blank?
                result = process_file(find_templates([layout_name], settings.layouts_directory)[0], locals.merge(content_for_layout: result), registers)
              end
              halt result
            end
            format.finish(&block)
          end

          def process_file file, locals, registers
            file = Pathname.new(file)
            result = File.read(file)

            while (ext = file.extname.gsub(".", "")).to_sym != settings.destination_format
              file = Pathname.new(file.to_s.gsub(".#{ext}", ""))
              result = send(ext, result)
            end
            send(settings.destination_format, result, { scope: locals }, registers)
          end

          def find_templates(names, base=settings.templates_directory)
            Dir[base.to_s + "/" + "{#{names.join(",")}}" + ".#{settings.destination_format}" + "{#{settings.allowed_engines.map { |ext_name| ".#{ext_name}" }.join(",")},}"]
          end
        end

        def self.registered app

          Liquid::Template.error_mode = :lax

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