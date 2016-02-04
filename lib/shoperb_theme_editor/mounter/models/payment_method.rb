module Shoperb module Theme module Editor
  module Mounter
    module Model
      class PaymentMethod < Base

        fields :id, :name, :state, :invoice_instructions, :instructions

        def payment_method
          self
        end

      end
    end
  end
end end end
