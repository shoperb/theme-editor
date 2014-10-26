module Shoperb
  module Mounter
    module Drop
      class PaymentMethod < Base

        def name
          record.name
        end

        def provider
          record.name
        end

        def state
          record.state
        end

        def invoice_instructions
          record.payment_method.invoice_instructions
        end

        def checkout_instructions
          record.payment_method.instructions
        end

      end
    end
  end
end