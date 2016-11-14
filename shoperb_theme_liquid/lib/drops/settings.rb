module Shoperb module Theme module Liquid module Drop
  class Settings < Base

    attr_reader :settings

    def initialize(custom_settings = {})
      @settings = custom_settings

      @settings.each do |key, value|
        define_singleton_method key do
          format_value(key, value)
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

    def format_value(key, value)
      value
    end
  end
end end end end
