module Shoperb
  module Mounter
    module Model
      class CartItem < Abstract::Base
        belongs_to :cart
        belongs_to :variant
        delegate :sku,                :to => :variant
        delegate :available?,         :to => :variant
        delegate :charge_taxes?,      :to => :variant
        delegate :require_shipping?,  :to => :variant
        delegate :product,            :to => :variant
      end
    end
  end
end

