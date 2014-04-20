module Shoperb
  module Editor
    module Models
      class Theme < SingletonBase

        def asset_url
          File.join('app', 'assets')
        end

        def render(name, locals, registers={})
          registers = {:theme => self, :layout => "layout"}.merge(registers)

          template, output = Template.render!(name, locals, registers)

          layout_name = template.registers[:layout]

          unless layout_name.blank?
            layout, output = Layout.render!(layout, locals.merge!(:content_for_layout => output), registers)
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

