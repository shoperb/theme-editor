module Shoperb module Theme module Liquid module Filter
  module Translate
    def translate(string)
      param = string.parameterize(".")

      @context.registers[:translate][@context.registers[:locale], param] || string
    end

    alias :t :translate
  end
end end end end
