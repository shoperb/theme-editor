module Liquid
  # Generates feedback form
  #
  # Usage:
  #
  # {% form 'name' %}
  #   html
  # {% endform %}
  # <input name="subject"> - will be used for subject. Other ones will be used for body
  #
  class Form < ::Liquid::Block
    SYNTAX = /(#{::Liquid::QuotedFragment})/

    def initialize(tag_name, markup, tokens)
      if markup =~ SYNTAX
        @subject = $1.strip[1..-2]
      else
        raise SyntaxError.new("Error in tag 'layout' - Valid syntax: form 'form_name'")
      end

      super
    end

    def render(context)
      context.stack do
        old_list = @nodelist

        @nodelist = []
        @nodelist << %(<form action='/submit-form' method="post">)
        @nodelist << %(<input type="text" name="contact_form_name" value="#{@subject}" style="color: black; display: none;" />)
        @nodelist << %(<input type="text" name="first_last_name" value="" style="color: black; display: none;" />)
        @nodelist << auth_token(context)
        @nodelist += old_list
        @nodelist << %(</form>)

        render_all(@nodelist, context)
      end
    end

    def auth_token(context)
      controller = context.registers[:controller]
      name       = controller.send(:request_forgery_protection_token).to_s
      value      = controller.send(:form_authenticity_token)

      %(<input type="hidden" name="#{name}" value="#{value}">)
    end
  end
end