module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Order < Base

        fields :id, :number, :token, :email, :total, :subtotal,
          :total_shipping, :total_taxes, :require_shipping,
          :require_taxation, :created_at, :state, :notes, :ship_address_id,
          :bill_address_id; :taxation_percentage

        def self.primary_key
          :number
        end

        # has_one :shipping_method
        def shipping_method
          @shipping_method ||= ShippingMethod.sample
        end

        def ship_address
          #Address.all.detect { |address| address.attributes[:id] == self.ship_address_id }
          @ship_address ||= Address.sample # as we use custom data
        end

        def bill_address
          # Address.all.detect { |address| address.attributes[:id] == self.bill_address_id }
          @bill_address ||= Address.sample # as we use custom data
        end

        def items
          # OrderItem.all.select { |item| item.attributes[:order_number] == self.id }
          OrderItem.all.map{|oi| oi.order=self;oi}
        end

        # belongs_to :payment_method
        def payment_method
          @payment_method ||= PaymentMethod.sample
        end

        # belongs_to :customer
        def customer
          @customer ||= Customer.sample
        end

        # belongs_to :currency
        def currency
          @currency ||= Currency.sample
        end

        def subtotal_wo_discount
          subtotal
        end

        def total_wo_discount
          total
        end

        def self.raw_data
          500.times.map do |i|
            {
              id: 1000 + i,
              number: "00#{i+1}",
              token: "a0f4add16292d40806ffccb6452a168a17768",
              email: "mail@shoperb.com",
              total: 0.2001e4,
              subtotal: 0.165372e4,
              total_shipping: 0.0,
              total_taxes: 0.347281e3,
              require_shipping: true,
              require_taxation: true,
              created_at: Time.parse("2019-05-23 11:59:50 UTC"),
              state: "new",
              notes: "", # possible nil
              ship_address_id: 104184, # possible nil
              bill_address_id: 104183, # possible nil
              taxation_percentage: "42",
              neto_discount: 1,
              bruto_discount: 2,
            }
          end.unshift({
            id: 100,
            number: "v01",
            token: "varianted-92d40806ffccb6452a168a17768",
            email: "mail@shoperb.com",
            total: 0.2001e4,
            subtotal: 0.165372e4,
            total_shipping: 0.0,
            total_taxes: 0.347281e3,
            require_shipping: true,
            require_taxation: true,
            created_at: Time.parse("2019-05-23 11:59:50 UTC"),
            state: "new",
            notes: "", # possible nil
            ship_address_id: 104184, # possible nil
            bill_address_id: 104183, # possible nil
            taxation_percentage: "42",
            neto_discount: 1,
            bruto_discount: 2,
            })
        end
      end
    end
  end
end end end
