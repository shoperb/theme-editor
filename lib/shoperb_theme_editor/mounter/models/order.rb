module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Order < Base

        fields :id, :number, :token, :email, :total, :subtotal, :total_shipping, :total_taxes, :require_shipping, :require_taxation, :created_at, :state, :notes, :ship_address_id, :bill_address_id

        def self.primary_key
          :number
        end

        has_one :shipping_method

        def ship_address
          Address.all.detect { |address| address.attributes[:id] == self.ship_address_id }
        end

        def bill_address
          Address.all.detect { |address| address.attributes[:id] == self.bill_address_id }
        end

        def items
          OrderItem.all.select { |item| item.attributes[:order_number] == self.id }
        end

        belongs_to :payment_method

        belongs_to :customer

        belongs_to :currency
      end
    end
  end
end end end
