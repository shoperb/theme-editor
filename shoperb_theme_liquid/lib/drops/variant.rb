module Shoperb module Theme module Liquid module Drop
  class Variant < Base

    def id
      record.id
    end

    def name
      record.name || record.product.name
    end

    def price
      record.price.to_f
    end

    def discount_price
      record.price_discount.try(:to_f)
    end

    def discount?
      record.discount_active?
    end

    def discount_period?
      record.has_discount_range?
    end

    def discount_start
      record.formatted_discount_start
    end

    def discount_end
      record.formatted_discount_end
    end

    def current_price
      record.active_price.to_f
    end

    def available?
      record.available?
    end

    def sku
      record.sku
    end

    def stock
      record.track_inventory? ? record.stock : nil
    end

    def weight
      record.weight
    end

    def width
      record.width
    end

    def height
      record.height
    end

    def depth
      record.depth
    end

    def options
      record.variant_attributes.map(&:value)
    end

    def image
      Image.new(record.image) if record.image
    end

    def images
      Collection.new(record.images).tap do |drop|
        drop.context = @context
      end
    end

    def attributes
      Collection.new(record.variant_attributes).tap do |drop|
        drop.context = @context
      end
    end

    def json
      {
        id: record.id,
        sku: record.sku,
        weight: record.weight,
        width: record.width,
        height: record.height,
        depth: record.depth,
        price: record.price,
        name: record.name,
        current_price: current_price,
        has_discounts: discount?,
        discount_price: discount_price,
        stock: stock,
        attributes: record.variant_attributes.map { |variant_attribute|
          {
            id: variant_attribute.id,
            name: variant_attribute.name,
            value: variant_attribute.value,
            handle: variant_attribute.handle
          }
        }
      }.to_json
    end

  end
end end end end
