module Shoperb
  module Mounter
    module Model
      class Variant < Base
        belongs_to :product
        belongs_to :currency
        has_many :variant_attributes
        has_many :cart_items
        delegate :public?,  :to => :product
        delegate :hidden?,  :to => :product
        delegate :image,    :to => :product, :prefix => false
        delegate :images,   :to => :product, :prefix => false
      end
    end
  end
end

