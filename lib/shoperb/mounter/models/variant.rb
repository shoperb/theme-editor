module Shoperb
  module Mounter
    module Model
      class Variant < Base

        fields :id, :sku, :stock, :weight, :width, :height, :depth, :price, :price_original, :price_discount, :discount_start, :discount_end, :allow_backorder, :track_inventory, :charge_taxes, :require_shipping, :position

        # TODO: Make sku actually unique so it can be used as a primary key.
        def self.primary_key
          "id"
        end

        belongs_to :product

        def available?(amount = 1)
          !track_inventory? || allow_backorder? || (stock > amount)
        end

        def active_price
          discount_active? ? price_discount : price
        end

        def discount_active?
          price_discount.present? || (has_discount_range? && (discount_start..discount_end).include?(Date.today))
        end

        def has_discount_range?
          discount_start.present? && discount_end.present?
        end

      end
    end
  end
end

