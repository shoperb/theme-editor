# frozen_string_literal: true
module Shoperb module Theme module Editor
  module Mounter
    module Model
      class OrderReturnItemEntity < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        fields :id, :customer_comment
        
        def order_item
          OrderItem.first
        end
        
        def self.raw_data
          [
            {id:1, customer_comment: "Lorem impsum" },
            {id:2, customer_comment: "Came broken" },
            {id:3, customer_comment: "Lost shiny surface" },
            {id:4, customer_comment: "Didn't like it" },
          ]
        end
      end
    end
  end
end end end
