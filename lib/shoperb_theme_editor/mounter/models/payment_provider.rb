module Shoperb module Theme module Editor
  module Mounter
    module Model
      class PaymentProvider < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        
        fields :id, :name, :type, :service, :public_key
        
        def self.raw_data
          [{
            id: 1,
            name: "Stripe",
            type: "stripe",
            service: "stripe",
            public_key: "pk_test_JqbMzr2NvnK25D5QEEm0OlZg"
          }]
        end
        
      end
    end
  end
end end end
