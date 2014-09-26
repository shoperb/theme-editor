module Shoperb
  module Mounter
    module Drop
      class Order < Delegate

        def items
          __to_drop__ Drop::Collection, :items
        end

        def customer
          __to_drop__ Drop::Customer, :customer
        end

        def currency
          __to_drop__ Drop::Currency, :currency
        end

        def shipping_address
          __to_drop__ Drop::Address, :shipping_address
        end

        def billing_address
          __to_drop__ Drop::Address, :billing_address
        end

        def url
          "/orders/#{@record.name}"
        end

      end
    end
  end
end