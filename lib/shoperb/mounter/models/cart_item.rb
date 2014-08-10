module Shoperb
  module Mounter
    module Model
      class CartItem < Abstract::Base
        belongs_to :cart
        belongs_to :product
      end
    end
  end
end

