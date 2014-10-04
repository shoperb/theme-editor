module Shoperb
  module Mounter
    module Model
      class CartItem < Base
        belongs_to :cart
        belongs_to :variant
        delegate :sku,                :to => :variant
        delegate :available?,         :to => :variant
        delegate :charge_taxes?,      :to => :variant
        delegate :require_shipping?,  :to => :variant
        delegate :product,            :to => :variant
        delegate :product_type,       :to => :product
      end
    end
  end
end

