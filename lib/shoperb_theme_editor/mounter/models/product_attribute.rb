module Shoperb module Theme module Editor
  module Mounter
    module Model
      class ProductAttribute < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        fields :id, :product_id, :attribute_key_id, :values

        translates :values
        belongs_to :attribute_key

        def self.primary_key
          :id
        end

        def name
          attribute_key.name
        end

        def handle
          attribute_key.handle
        end

      end
    end
  end
end end end
