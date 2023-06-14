module Shoperb module Theme module Editor
  module Mounter
    module Model
      class CartItem < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :variant_sku, :name, :created_at, :updated_at
        c_fields :id,         cast: Integer
        c_fields :amount,     cast: BigDecimal
        c_fields :variant_id, cast: Integer
        c_fields :by_subscription, cast: TrueClass

        belongs_to :variant

        def self.primary_key
          :id
        end

        delegate :product, to: :variant
        delegate :sku, to: :variant
        delegate :require_shipping?,  to: :variant

        def cart
          Cart.first
        end

        def weight
          amount * variant.weight.to_d
        end

        def total
          amount * overwritten_price(variant.active_price.to_d)
        end

        def neto_total
          amount * overwritten_price(variant.neto_active_price.to_d)
        end

        def bruto_total
          amount * overwritten_price(variant.bruto_active_price.to_d)
        end

        def price
          overwritten_price(variant.price)
        end

        def low_on_stock?
          variant.present? && variant.available? && !variant.available?(:warehouse, amount)
        end

        def out_of_stock?
          variant.nil? || !variant.available? || !variant.available?(:warehouse, amount)
        end

        def item_original_id
          nil
        end

        def overwritten_price sum
          if by_subscription
            0.to_d
          else
            sum
          end
        end

      end
    end
  end
end end end
