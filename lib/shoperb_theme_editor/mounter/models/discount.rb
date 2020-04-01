module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Discount < Base

        fields :id, :name, :code, :type, :status, :minimum_order_amount, :target_type,
          :start_date, :end_date, :amount, :region_specific, :shipping_region_ids

        def self.primary_key
          "id"
        end

        has_many :discount_variants

        def variants
          discount_variants.map(&:variant)
        end
        class << self
          def assign records
            self.delete_all
            self.data = records.map(&method(:filtered_attributes))

            count = 1
            discs_variants=records.each_with_object([]){|r,a|
              next if r["target_type"]!="variants"
              r["target_ids"].each do |variant_id|
                a << {"id"=> count, "discount_id"=> r["id"], "variant_id"=> variant_id}
                count+=1
              end
            }
            Mounter::Model::DiscountVariant.assign discs_variants

            records
          end
        end
      end
    end
  end
end end end
