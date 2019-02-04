module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Review < Base

        fields :id,
               :product_id,
               :customer_id,
               :state,
               :title,
               :body,
               :rating,
               :created_at,
               :updated_at

        def self.primary_key
          :id
        end

        belongs_to :customer
        belongs_to :product

      end
    end
  end
end end end
