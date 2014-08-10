module Shoperb
  module Mounter
    module Model
      class Variant < Abstract::Base
        belongs_to :product
        belongs_to :currency
        has_many :variant_attributes
      end
    end
  end
end

