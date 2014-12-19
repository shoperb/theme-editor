module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Customer < Base

        def name
          record.name
        end

        def first_name
          record.first_name
        end

        def last_name
          record.last_name
        end

        def email
          record.email
        end

        def accepts_newsletter?
          record.newsletter
        end

        def registred?
          record.active?
        end

        def last_billing_address
          Address.new(record.last_bill_address)
        end

        def last_shipping_address
          Address.new(record.last_ship_address)
        end

        def addresses
          Collection.new(record.addresses)
        end

      end
    end
  end
end end end
