module Shoperb module Theme module Editor
  module Mounter
    module Model
      class DiscountVariant < Base

        fields :id, :discount_id, :variant_id

        belongs_to :discount
        belongs_to :variant
      end
    end
  end
end end end
