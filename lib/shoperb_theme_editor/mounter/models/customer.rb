module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Customer < Base

        fields :id, :last_bill_address_id, :last_ship_address_id,
          :first_name, :last_name, :email, :newsletter, :active,
          :discount_pct, :recommended_products_ids, :custom_field_values

        has_many :orders

        def last_bill_address
          Address.all.detect { |address| attributes[:last_bill_address_id] == address.attributes[:id] }
        end

        def last_ship_address
          Address.all.detect { |address| attributes[:last_ship_address_id] == address.attributes[:id] }
        end

        def addresses
          check = { owner_type: "Customer", owner_id: attributes[:id] }.with_indifferent_access
          Address.all.select { |address|
            address.attributes.slice(:owner_type, :owner_id).with_indifferent_access == check
          }
        end

        def recommended_products
          possible = attributes.fetch(:recommended_products_ids, []).map(&:to_s)
          Product.active.select { |product| possible.include?(product.attributes[:id].to_s) }
        end
      end
    end
  end
end end end
