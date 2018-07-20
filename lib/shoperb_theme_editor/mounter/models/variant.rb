module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Variant < Base

        fields :id, :sku, :warehouse_stock, :weight, :width, :height, :depth, :price,
               :price_original, :price_discount, :discount_start, :discount_end,
               :allow_backorder, :track_inventory, :charge_taxes, :require_shipping,
               :digital, :url, :position, :stock_amounts, :product_id

        # TODO: Make sku actually unique so it can be used as a primary key.
        def self.primary_key
          "id"
        end

        belongs_to :product
        has_many :variant_attributes
        has_many :discount_variants

        attr_accessor :customer
        attr_accessor :discount

        def discounts
          discount_variants.map(&:discount)
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

        def self.available
          all.select(&:available?)
        end

        def available?(_ = nil, amount = 1)
          !track_inventory? || allow_backorder? || (!stock || stock >= amount)
        end

        alias_attribute :stock, :warehouse_stock

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
