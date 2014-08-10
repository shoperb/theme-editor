module Shoperb
  module Mounter
    module Model
      class OrderItemAttribute < Abstract::Base
        belongs_to :order_item
      end
    end
  end
end

