module Shoperb
  module Mounter
    module Model
      class OrderItem < Abstract::Base
        belongs_to :order
        has_many :order_item_attributes
      end
    end
  end
end

