module Shoperb module Theme module Liquid module Drop
  class Settings < Base
    def initialize(custom_settings = {})
      @settings = custom_settings

      @settings.each do |key, value|
        self.class.send(:define_method, key) { format_value(key, value) }
      end
    end

    private

    def format_value(key, value)
      "'/*settings.#{key}[*/#{value}/*]*/'"
    end
  end
end end end end
