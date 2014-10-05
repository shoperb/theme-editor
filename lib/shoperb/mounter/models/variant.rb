module Shoperb
  module Mounter
    module Model
      class Variant < Base

        fields :sku, :stock, :weight, :width, :height, :depth, :price, :price_original, :price_discount, :discount_start, :discount_end, :allow_backorder, :track_inventory, :charge_taxes, :require_shipping, :position

        def self.primary_key
          :sku
        end

        belongs_to :product

      end
    end
  end
end

