module Shoperb
  module Mounter
    module Drop
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
            Image.new(image)
          end
        end

      end
    end
  end
end