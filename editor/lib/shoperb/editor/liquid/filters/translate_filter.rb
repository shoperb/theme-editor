module TranslateFilter
  def translate(string)
    param = string.parameterize(".")
    theme = @context.registers[:theme]
    theme.persist_translation.translate(::Globalize.locale, param) || string
  end

  alias :t :translate
end