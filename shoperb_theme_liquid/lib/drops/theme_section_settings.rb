module Shoperb module Theme module Liquid module Drop
  class ThemeSectionSettings < Base

    def initialize(settings, translations)
      @settings = settings || {}
      @translations = translations || {}

      @settings.each do |key, value|
        if value.is_a? Hash
          self.class.new(value, current_locale => (translations[current_locale] || {})[key])
        else
          define_singleton_method key do
            (@translations[current_locale] || {})[key] || value
          end
        end
      end
    end


    def self.invokable?(method_name)
      true
    end

    def method_missing *args
      nil
    end

    private

    def current_locale
      @context.registers[:locale]
    end
  end
end end end end
