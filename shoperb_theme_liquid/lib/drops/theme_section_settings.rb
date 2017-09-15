module Shoperb module Theme module Liquid module Drop
  class ThemeSectionSettings < Base

    attr_reader :section

    def initialize(section)
      @section = section
      @settings = section.settings || {}
      @translations = section.translations || {}

      @settings.each do |key, value|
        define_singleton_method key do
          if image = image_object(key)
            ThemeSectionImage.new(image)
          else
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

    def image_object(handle)
      image = section_images[handle]
      images.detect { |i| i.id == image['id'] } if image
    end

    def images
      @images ||= Image.where(id: image_ids)
    end

    def image_ids
      section_images.values.map{ |i| i['id'] }
    end

    def section_images
      section['images'] || {}
    end
  end
end end end end

