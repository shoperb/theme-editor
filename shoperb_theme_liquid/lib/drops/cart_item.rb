module Shoperb module Theme module Liquid module Drop
  class CartItem < Base

    def id
      record.id
    end

    def sku
      record.sku
    end

    def name
      record.variant.name
    end

    def quantity
      record.amount
    end

    def stock
      record.stock
    end

    def weight
      record.variant.weight
    end

    def price
      record.variant.price.to_f
    end

    def discount_price
      record.variant.price_discount.try(:to_f)
    end

    def active_price
      record.variant.active_price.to_f
    end

    def discount?
      record.variant.discount_active?
    end

    def discount_start
      record.variant.formatted_discount_start
    end

    def discount_end
      record.variant.formatted_discount_end
    end

    def total
      record.total
    end

    def total_weight
      record.weight
    end

    def requires_taxing?
      record.variant.charge_taxes?
    end

    def requires_shipping?
      record.variant.require_shipping?
    end

    def vendor
      record.vendor.try(:to_liquid, @context)
    end

    def type
      record.product.try(:product_type).try(:to_liquid, @context)
    end

    def product
      record.product.try(:to_liquid, @context)
    end

    def variant
      record.variant.try(:to_liquid, @context)
    end

  end
end end end end
