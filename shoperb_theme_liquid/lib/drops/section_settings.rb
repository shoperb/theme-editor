module Shoperb module Theme module Liquid module Drop
  class SectionSettings < Base

    def initialize(section, settings = nil)
      @section = section
      @settings = settings || @section.settings

      @settings.each do |key, value|
        if value.is_a? Hash
          self.class.new(@section, value)
        else
          define_singleton_method key do
            value
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
  end
end end end end
