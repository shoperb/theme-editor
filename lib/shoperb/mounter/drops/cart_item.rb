module Shoperb
  module Mounter
    module Drop
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
          record.variant.price
        end

        def discount_price
          record.variant.price_discount
        end

        def active_price
          record.variant.active_price
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
          Vendor.new(record.vendor)
        end

        def type
          ProductType.new(record.product.product_type)
        end

        def product
          Product.new(record.product)
        end

        def variant
          Variant.new(record.variant)
        end

      end
    end
  end
end