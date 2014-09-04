module Shoperb
  module Mounter
    module Liquid
      module Tag
        class Form < ::Liquid::Block
          SYNTAX = /(#{::Liquid::QuotedFragment})/

          def initialize(tag_name, markup, tokens)
            if markup =~ SYNTAX
              @subject = $1.strip[1..-2]
            else
              raise Error.new("Error in tag 'form' - Valid syntax: form 'form_name'")
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
              @nodelist += old_list
              @nodelist << %(</form>)

              render_all(@nodelist, context)
            end
          end
        end
      end
    end
  end
end