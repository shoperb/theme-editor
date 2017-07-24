module Shoperb module Theme module Liquid module Tag
  class Section < Include

    def render(context)
      context.stack do
        section_id = context[@template_name]
        section_data = Shoperb::Theme::Editor.settings_data['sections'][section_id]

        context['section'] = Drop::ThemeSection.new(section_id, section_data)

        super
      end
    end

    protected

    def default_file_system(context)
      context.registers[:sections_file_reader]
    end

  end
end end end end
