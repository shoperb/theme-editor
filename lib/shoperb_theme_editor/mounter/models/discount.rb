module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Discount < Base

        fields :id, :name, :code, :type, :status, :minimum_order_amount, :target_type,
          :start_date, :end_date, :amount, :region_specific, :shipping_region_ids

        has_many :discount_variants

        def variants
          discount_variants.map(&:variant)
        end
      end
    end
  end
end end end
