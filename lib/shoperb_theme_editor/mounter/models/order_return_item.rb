# frozen_string_literal: true
module Shoperb module Theme module Editor
  module Mounter
    module Model
      class OrderReturnItem < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        fields :id, :amount
        
        def order_item
          OrderItem.first
        end

        def entities
          OrderReturnItemEntity.all
        end
        
        def self.raw_data
          [
            {id:1, amount: 0 },
            {id:2, amount: 0 },
            {id:3, amount: 0 },
            {id:4, amount: 3 },
          ]
        end
      end
    end
  end
end end end
