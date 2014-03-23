module Shoperb
  module Editor
    module Models
      class Theme < SingletonBase

        def asset_url
          File.join('app','assets')
        end

        def render(name, locals)
          registers = { :theme => self, :layout => :"../layouts/layout" }

          template = Template.all.detect { |template| /#{name}.liquid\z/ =~ template.path }.parse

          binding.pry

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

