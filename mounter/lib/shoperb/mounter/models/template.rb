module Shoperb
  module Mounter
    module Models
      class Template < Base

        def render context
          template = Liquid::Template.new
          template.parse File.read(filepath)
          content = template.render(context)
          layout_name = template.registers[:layout] || 'layout'
          if layout_name
            if layout = mounting_point.layouts[layout_name]
              context['content_for_layout'] = content
              content = layout.render(context)
            end
          end
          content
        end

      end
    end
  end
end

