module Shoperb module Theme module Editor
  module Mounter
    module Model
      class OrderItem < Base
        fields :id, :name, :amount, :sku, :weight, :width, :depth,
          :price, :total_without_taxes, :total_wout_correlation,
          :total_weight, :total_taxes, :require_shipping, :charge_taxes,
          :item_original_id, :by_subscription

        belongs_to :order
        has_many :item_attributes, class_name: OrderItemAttribute.to_s

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
          @variant ||= [Variant.first, nil].sample
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
