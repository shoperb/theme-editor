module Shoperb
  module Mounter
    module Liquid
      module Tag
        class Layout < ::Liquid::Tag

          SYNTAX = /(#{::Liquid::QuotedFragment}+)(\s+(#{::Liquid::QuotedFragment}+))?/

          def initialize(tag_name, markup, tokens)
            if markup =~ ::Liquid::Tag::SYNTAX
              @layout_name = $1
            else
              raise Error.new("Error in tag 'layout' - Valid syntax: layout '[layout|none]'")
            end

            super
          end

          def render(context)
            context.registers[:layouts] = @layout_name == "none" ? nil : @layout_name[1..-2]
            nil
          end

        end
      end
    end
  end
end