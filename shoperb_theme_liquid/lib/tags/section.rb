module Shoperb module Theme module Liquid module Tag
  class Section < Include

    def render(context)
      context.stack do
        section_data = Shoperb::Theme::Editor.settings_data[@template_name] # TODO check template name
        context['section'] = Drop::ThemeSection.new(@template_name, section_data)

        super
      end
    end

    protected

    def default_file_system(context)
      context.registers[:sections_file_reader]
    end

  end
end end end end
