module Shoperb module Theme module Liquid module Tag
  class Section < Include

    def render(context)
      context.stack do
        section = ::Shoperb::Theme::Editor::Mounter::Model::Section.new(handle: @template_name)
        context['section'] = section.to_liquid(context)
        super # reading/saving schema
        super # with settings derived from schema defaults
      end
    end

    protected

    def default_file_system(context)
      context.registers[:sections_file_reader]
    end

  end
end end end end

