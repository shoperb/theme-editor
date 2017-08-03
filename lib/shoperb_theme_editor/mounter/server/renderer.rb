module Tilt
  class LiquidTemplate
    def evaluate scope, context, *args, &block
      @engine.render(context)
    end
  end
end
module Shoperb module Theme module Editor
  module Mounter
    class Server
      module Renderer

        module Helpers
          def respond(templates, locals={}, registers={}, dir=settings.templates_directory, &block)
            result = template_result(templates, locals, registers, dir)
            format = Sinatra::RespondWith::Format.new(self)
            halt result if result
            format.finish(&block)
          end

          def content_for_template(template, locals, registers)
            settings_data = Shoperb::Theme::Editor.settings_data
            return nil unless settings_data && settings_data["content_for_#{template}"]

            section_ids = settings_data["content_for_#{template}"]

            section_ids.map do |id|
              data = settings_data['sections'][id]
              file = template_path(data['type'], settings.sections_directory)
              section_drop = Shoperb::Theme::Liquid::Drop::ThemeSection.new(id, data)
              process_file(file, locals.merge(section: section_drop), registers)
            end.join(' ')
          end

          def respond_email(templates, locals={}, registers={}, &block)
            respond(templates, locals, {layout:nil}.reverse_merge(registers), settings.emails_directory, &block)
          end

          def process_file file, locals, registers
            file = Pathname.new(file)
            result = File.read(file).force_encoding("UTF-8").gsub("\xC2\xA0", " ")

            while (ext = file.extname.gsub(".", "")).to_sym != settings.destination_format
              file = Pathname.new(file.to_s.gsub(".#{ext}", ""))
              result = send(ext, result)
            end

            Liquid::Template.parse(result).render!(locals.stringify_keys!, :registers => registers)
          end

          def template_result(templates, locals={}, registers={}, dir=settings.templates_directory)
            locals, registers = registers_and_locals(locals, registers)
            templates = [templates].flatten
            if (template = template_name(templates, dir))
              locals.merge!(template_name: template.to_s)
              locals[:content_for_template] = content_for_template(template.to_s, locals, registers)

              file = template_path(template, dir)
              result = process_file(file, locals, registers)
              unless (layout_name = registers[:layout].to_s).blank?
                result = process_file(template_path(layout_name, settings.layouts_directory), locals.merge(content_for_layout: result), registers)
              end
              result
            end
          end

          def registers_and_locals locals={}, registers={}
            registers.reverse_merge!(
              replace_locale: ->(locale) { request.fullpath.gsub(/\A(?=#{shop.possible_languages.map{|s|"/#{s}"}.join("|")}|)\/(.*)/, "/#{locale}/\\1") },
              empty_collection: -> { Drop::Collection.new(Kaminari::PaginatableArray.new) },
              controller: self,
              asset_url: ->(url, *args) { "/system/assets/#{url}" },
              translate: Translations.method(:translate),
              locale: Translations.locale,
              shop: shop,
              category: request.env[:current_category],
              request_forgery_protection_token: -> { %(<input type="hidden" name="" value="">) },
              models: Model,
              default_partials: Pathname.new(__FILE__) + "../partials",
              sections_file_reader: sections_file_reader,
              templates_file_system: templates_file_reader
            )

            [
              locals.reverse_merge(default_locals),
              registers.reverse_merge({layout: "layout"})
            ]
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

          def sections_file_reader
            ::Liquid::LocalFileSystem.new(settings.sections_directory, "%s.liquid")
          end

          def templates_file_reader
            ::Liquid::LocalFileSystem.new(settings.templates_directory)
          end
        end

        def self.registered app

          Liquid::Template.error_mode = :strict

          app.register Sinatra::RespondWith
          app.helpers Helpers
          app.set :templates_directory, Proc.new { File.join(root, "templates") }
          app.set :layouts_directory, Proc.new { File.join(root, "layouts") }
          app.set :emails_directory, Proc.new { File.join(root, "emails") }
          app.set :sections_directory, Proc.new { File.join(root, "sections") }

          Liquid::Template.file_system = ::Liquid::LocalFileSystem.new(app.settings.templates_directory)

          app.set :destination_format, :liquid
          app.set :allowed_engines, [:haml]
        end

      end
    end
  end
end end end
