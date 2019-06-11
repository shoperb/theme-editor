# frozen_string_literal: true
module Shoperb module Theme module Editor
  module Mounter
    module Model
      class OrderReturnItem < Base
        fields :id, :quantity_sent, :quantity_received, :quantity_requested
        
        def order_item
          OrderItem.first
        end
        
        def self.raw_data
          [
            {id:1, quantity_sent: 0, quantity_received: 0, quantity_requested: 0 },
            {id:2, quantity_sent: 1, quantity_received: 0, quantity_requested: 0 },
            {id:3, quantity_sent: 2, quantity_received: 1, quantity_requested: 0 },
            {id:4, quantity_sent: 3, quantity_received: 3, quantity_requested: 3 },
          ]
        end
      end
    end
  end
end end end
