module Shoperb module Theme module Editor
  module Mounter
    module Model
      class OrderItem < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        fields :id, :name, :sku
        c_fields :order_id, :item_original_id, cast: Integer
        c_fields :require_shipping, :charge_taxes, :brand_id, cast: TrueClass
        c_fields :by_subscription, :digital, cast: TrueClass
        c_fields :amount, :amount_step,:amount_step_unit, cast: BigDecimal
        c_fields :weight, :width, :depth, cast: BigDecimal
        c_fields :total_weight, :total_taxes, cast: BigDecimal
        c_fields :price, :total_without_taxes, :total_wout_correlation, cast: BigDecimal

        belongs_to :order
        has_many :item_attributes, class_name: OrderItemAttribute.to_s

        def order
          Order.first
        end

        def digital?
          digital
        end

        def category
          @category ||= [Category.first, nil].sample
        end

        def product
          @product ||= [Product.first, nil].sample
        end

        def variant
          return @variant if defined?(@variant)

          @variant = if order&.token.start_with?("varianted")
            Variant.all.sample
          else
            [Variant.first, nil].sample
          end
        end

        def brand
          Vendor.find(id: brand_id) if brand_id
        end

        def item_attributes
          variant&.variant_attributes || []
        end

        def url
          variant&.url
        end

        def product_id
          product&.id || 3
        end

        def variant_id
          variant&.id || 4
        end

        def self.raw_data
          [
            {
              id: 1,
              name: "Subscriptional product",
              amount: 1,
              sku: nil,
              weight: nil,
              width: nil,
              height: nil,
              depth: nil,
              price: 0.11e3,
              total_without_taxes: 0.11e3,
              total_wout_correlation: 0.132e3,
              total_weight: 0,
              total_taxes: 0.22e2,
              digital: true,
              download_url: "http://shoperb.com/store_checkout_download_url",
              charge_taxes: true,
              by_subscription: true,
            },
            {
              id: 2,
              name: "ProductForGA",
              amount: 1,
              sku: nil,
              weight: nil,
              width: nil,
              height: nil,
              depth: nil,
              price: 0.11e3,
              total_without_taxes: 0.11e3,
              total_wout_correlation: 0.132e3,
              total_weight: 0,
              total_taxes: 0.22e2,
              digital: true,
              download_url: "http://shoperb.com/store_checkout_download_url",
              charge_taxes: true,
              by_subscription: false,
            },
            {
              id: 3,
              name: "ProductForGA 2",
              amount: 2,
              sku: "3213-1111",
              weight: 1,
              width: 2,
              height: 3,
              depth: 4,
              price: 0.22e3,
              total_without_taxes: 0.22e3,
              total_wout_correlation: 0.232e3,
              total_weight: 2,
              total_taxes: 0.22e2,
              digital: false,
              download_url: nil,
              charge_taxes: true,
              by_subscription: false
            }
          ]
        end
      end
    end
  end
end end end
