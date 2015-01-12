module Shoperb module Theme module Liquid module Drop
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
      record.category.try(:to_liquid, @context)
    end

    def vendor
      record.vendor.try(:to_liquid, @context)
    end

    def type
      record.product_type.try(:to_liquid, @context)
    end

    def variants
      Variants.new(record.variants).tap do |drop|
        drop.context = @context
      end
    end

    def image
      record.image.try(:to_liquid, @context)
    end

    def images
      Collection.new(record.images).tap do |drop|
        drop.context = @context
      end
    end

    def attributes
      Collection.new(record.product_attributes).tap do |drop|
        drop.context = @context
      end
    end

    def variant_properties
      Collection.new(record.variant_attributes).tap do |drop|
        drop.context = @context
      end
    end

    def others_in_category
      return Products.new([]).tap do |drop|
        drop.context = @context
      end unless record.category

      Products.new(record.category.products_for_self_and_children).tap do |drop|
        drop.context = @context
      end
    end

  end
end end end end
