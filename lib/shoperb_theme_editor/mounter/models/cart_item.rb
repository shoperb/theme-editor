module Shoperb module Theme module Editor
  module Mounter
    module Model
      class CartItem < Base

        fields :variant_sku, :name, :amount, :created_at, :updated_at

        belongs_to :variant

        def self.primary_key
          :id
        end

        delegate :product, to: :variant
        delegate :sku, to: :variant
        delegate :require_shipping?,  :to => :variant

        def cart
          Cart.first
        end

        def weight
          amount * variant.weight.to_d
        end

        def total
          amount * variant.active_price.to_d
        end

        def neto_total
          amount * variant.neto_active_price.to_d
        end

        def bruto_total
          amount * variant.bruto_active_price.to_d
        end

        def low_on_stock?
          variant.present? && variant.available? && !variant.available?(amount)
        end

        def out_of_stock?
          variant.nil? || !variant.available? || !variant.available?(amount)
        end

      end
    end
  end
end end end
