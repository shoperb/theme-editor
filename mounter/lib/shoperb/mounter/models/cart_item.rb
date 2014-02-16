module Shoperb
  module Mounter
    module Models
      class CartItem < Base
        belongs_to :cart
        belongs_to :product
      end
    end
  end
end

