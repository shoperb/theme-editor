module Shoperb module Theme module Editor
  module Mounter
    module Model
      class PaymentCard < Base
        
        fields :id, :service, :card
        
        def self.raw_data
          [{
            id: 2,
            service:"stripe",
            card: {"name"=>nil, "brand"=>"Visa", "last4"=>"4242","country"=>"US", "exp_year"=>2022, "exp_month"=>11, "type"=>"credit"}
          }]
        end
        
      end
    end
  end
end end end
