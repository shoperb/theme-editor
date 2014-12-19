module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Product < Base

        def id
          record.id
        end

        def name
          record.name
        end

        def handle
          record.slug
        end

        def url
          default_url handle
        end

        def max_price
          record.maximum_price
        end

        def min_price
          record.minimum_price
        end
        alias :price :min_price

        def min_discount_price
          record.minimum_discount_price
        end

        def max_discount_price
          record.maximum_discount_price
        end

        def min_active_price
          record.minimum_active_price
        end

        def max_active_price
          record.maximum_active_price
        end

        def available?
          record.available?
        end

        def description
          record.description
        end

        def options
          record.product_attributes.map(&:value)
        end

        def category
          Category.new(record.category)
        end

        def vendor
          Vendor.new(record.vendor)
        end

        def type
          ProductType.new(record.product_type)
        end

        def variants
          Variants.new(record.variants)
        end

        def image
          Image.new(record.image) if record.image
        end

        def images
          Collection.new(record.images)
        end

        def attributes
          Collection.new(record.product_attributes)
        end

        def variant_properties
          Collection.new(record.variant_attributes)
        end

        def others_in_category
          return Products.new([]) unless record.category

          Products.new(record.category.products_for_self_and_children)
        end

      end
    end
  end
end end end
