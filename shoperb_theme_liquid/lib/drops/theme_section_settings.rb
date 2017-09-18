module Shoperb module Theme module Liquid module Drop
  class ThemeSectionSettings < ThemeSettings

    attr_reader :section

    def initialize(section)
      @section = section
      @settings = section['settings'] || {}
      @translations = section['translations'] || {}

      super(@settings)
    end

    protected

    def format_value(key, value)
      (@translations[current_locale] || {})[key] || value
    end

    def current_locale
      I18n.locale.to_s
    end
  end
end end end end

