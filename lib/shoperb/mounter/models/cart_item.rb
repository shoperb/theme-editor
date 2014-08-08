module Shoperb
  module Mounter
    module Model
      class CartItem < Abstract::Base
        belongs_to :cart, attribute: :name
        belongs_to :product, attribute: :name
      end
    end
  end
end

