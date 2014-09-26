module Shoperb
  module Mounter
    module Drop
      class Product < Delegate

        def url
          "/products/#{@record.name}"
        end

        def category
          __to_drop__ Drop::Category, :category
        end

        def vendor
          __to_drop__ Drop::Vendor, :vendor
        end

        def type
          __to_drop__ Drop::ProductType, :product_type
        end

        def variants
          Drop::Variants.new(@record.variants)
        end

        def image
          __to_drop__ Drop::Image, :image
        end

        def images
          Drop::Collection.new(@record.images)
        end

        def attributes
          Drop::Collection.new @record.product_attributes
        end

        def variant_properties
          Drop::Collection.new(@record.variant_attributes)
        end

        def others_in_category
          Drop::Products.new(@record.others_in_category)
        end

      end
    end
  end
end