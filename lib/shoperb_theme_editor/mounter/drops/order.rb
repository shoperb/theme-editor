module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Order < Base

        def name
          "#" + record.number
        end

        def number
          record.number
        end

        def token
          record.token
        end

        def email
          record.email
        end

        def total
          record.total
        end

        def subtotal
          record.subtotal
        end

        def total_shipping
          record.total_shipping
        end

        def total_taxes
          record.total_taxes
        end

        def requires_shipping?
          record.require_shipping?
        end

        def requires_taxation?
          record.require_taxation?
        end

        def created_at
          record.created_at
        end

        def state
          record.state
        end

        def notes
          record.notes
        end

        def payment_method
          record.payment_method.to_liquid
        end

        def payment_method_name
          record.payment_method.name
        end

        def billing_address
          Address.new(record.bill_address)
        end

        def shipping_address?
          !!record.ship_address
        end

        def shipping_address
          Address.new(record.ship_address)
        end

        def items
          Collection.new(record.items)
        end

        def customer
          Customer.new(record.customer)
        end

        def currency
          Currency.new(record.currency)
        end


        def url
          default_url number
        end

      end
    end
  end
end end end
