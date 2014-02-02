module Liquid
  class Layout < Tag

    SYNTAX = /(#{QuotedFragment}+)(\s+(#{QuotedFragment}+))?/

    def initialize(tag_name, markup, tokens)
      if markup =~ SYNTAX
        @layout_name = $1
      else
        raise SyntaxError.new("Error in tag 'layout' - Valid syntax: layout '[layout|none]'")
      end

      super
    end

    def render(context)
      context.registers[:layout] = @layout_name == "none" ? nil : @layout_name
      nil
    end

  end

  ::Liquid::Template.register_tag('layout', Layout)
end