require "singleton"
module Shoperb
  module Mounter
    module Models
      class Theme < Base
        include Singleton

        def asset_url
          File.join('app','assets')
        end

        def render(name, locals, controller)
          registers = {:controller => controller, :theme => self, :layout => "layout", mounting_point: mounting_point}

          template = mounting_point.templates.fetch(name.to_s).parse

          output = template.render!(locals.stringify_keys!, :registers => registers)

          layout = template.registers[:layout]

          unless layout.blank?
            layout = mounting_point.layouts.fetch(layout).parse
            output = layout.render!(locals.merge!(:content_for_layout => output).stringify_keys!, :registers => registers)
          end

          output
        end

        def persist_translation
          Translation.instance
        end
      end
    end
  end
end

