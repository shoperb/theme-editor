module Liquid

  class Include

    def render(context)
      partial = context.registers[:mounting_point].resources["fragments"]["_#{@template_name[1..-2]}"]
      partial.render(context)
    end

  end

  ::Liquid::Template.register_tag('include', Include)
end