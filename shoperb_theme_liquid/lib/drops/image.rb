module Shoperb module Theme module Liquid module Drop
  class Image < Base

    def width
      record.original_width || record.width
    end

    def height
      record.original_height || record.height
    end

    def url
      record.url
    end

    def before_method(method, *args)
      if image = record.image_sizes.detect { |s| s.name == method.to_s }
        image.to_liquid(@context)
        #else
        #  self
      end
    end

  end
end end end end
