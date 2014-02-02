module Shoperb
  module Editor
    module Liquid
      module Filters
        module Translate

          def translate(string)
            param = string.parameterize(".")

            #theme = @context.registers[:theme]
            #theme.translation.translate(::I18n.locale, param) || string
            string
          end

          alias :t :translate
        end

        ::Liquid::Template.register_filter(Translate)

      end
    end
  end
end