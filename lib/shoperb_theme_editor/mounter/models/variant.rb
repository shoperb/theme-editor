module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Variant < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :sku, :warehouse_stock, :weight, :width, :height, :depth,
               :barcode, :discount_start, :discount_end,
               :charge_taxes,
               :digital, :url, :position, :stock_amounts, :product_id, :compare_at,
               :gift_card_value, :num_in_pack, :amount_step,:amount_step_unit
        c_fields :track_inventory, cast: TrueClass
        c_fields :allow_backorder, cast: TrueClass
        c_fields :require_shipping, cast: TrueClass
        c_fields :charge_taxes, cast: TrueClass
        c_fields :price, :price_original, :price_discount, cast: BigDecimal

        belongs_to :product
        has_many :variant_attributes
        has_many :discount_variants

        attr_accessor :customer
        attr_accessor :discount

        def discounts
          discount_variants.map(&:discount).compact
        end

        def discount
          @discount || discounts.first
        end

        def name
          "".tap do |name|
            name << product.name
            name << " - #{names.join(" / ")}" unless names.empty?
          end
        end

        def names
          variant_attributes.map(&:value)
        end

        dataset_module do
          def available
            to_a.select(&:available?)
          end
        end

        def available?(_ = nil, amount = 1)
          !track_inventory? || allow_backorder? || (!stock || stock >= amount)
        end

        def stock(*args)
          warehouse_stock
        end
        
        def warehouse_stock
          attributes[__method__].to_d
        end
        def amount_step
          attributes[__method__].to_d
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

        def formatted_discount_start
          discount.stard_date.to_s if discount && discount.stard_date.present?
        end

        def formatted_discount_end
          discount.end_date.to_s if discount && discount.end_date.present?
        end

        def images
          Image.all.select { |image| image.entity == self }
        end

        def image
          images.first
        end
      end
    end
  end
end end end
