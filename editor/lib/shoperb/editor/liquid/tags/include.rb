module Liquid

  class Include

    def render(context)
      partial = context.registers[:mounting_point].fragments["_#{@template_name[1..-2]}"]
      partial.parse.render(context)
    end

  end

  ::Liquid::Template.register_tag('include', Include)
end