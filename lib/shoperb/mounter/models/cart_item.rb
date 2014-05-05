module Shoperb
  module Mounter
    module Models
      class CartItem < Base
        belongs_to :cart, attribute: :name
        belongs_to :product, attribute: :name
      end
    end
  end
end

