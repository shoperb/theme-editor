module Shoperb
  module Mounter
    module Drop
      class Customer < Delegate

        def last_billing_address
          __to_drop__ Drop::Address, :last_billing_address
        end

        def last_shipping_address
          __to_drop__ Drop::Address, :last_shipping_address
        end

        def addresses
          __to_drop__ Drop::Collection, :addresses
        end

      end
    end
  end
end