module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Customer < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :last_bill_address_id, :last_ship_address_id,
          :first_name, :last_name, :email, :newsletter, :active,
          :discount_pct, :recommended_products_ids
        c_fields :company, cast: TrueClass


        def name
          "#{first_name} #{last_name}".strip
        end

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

        def customer_groups
          CustomerGroup.where(customer_ids: id)
        end

        def orders
          Order.dataset
        end

        def recommended_products
          possible = attributes.fetch(:recommended_products_ids, []).map(&:to_s)
          Product.active.select { |product| possible.include?(product.attributes[:id].to_s) }
        end

        def purchased_variant?(variant)
          [true, false].sample
        end

        def existing_order_returns
          OrderReturn.dataset
        end

        def order_returns
          new_order_returns
        end

        def new_order_returns
          order = Order.last
          {order.id => order}
        end

        def not_returned_items
          0
        end

        def subscriptions
          CustomerSubscription.dataset
        end
      end
    end
  end
end end end
