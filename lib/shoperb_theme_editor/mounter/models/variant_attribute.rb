module Shoperb module Theme module Editor
  module Mounter
    module Model
      class VariantAttribute < Base

        fields :id, :value, :translations, :attribute_key

        translates :value

        def initialize(*args)
          super(*args)
          @attributes[:name] = name
        end

        def self.primary_key
          "id"
        end

        belongs_to :variant

        def name
          attribute_key['name']
        end

        def handle
          attribute_key['handle']
        end


        # for order_item_attribute
        def owner
          name
        end
        def self.from_variant
          all
        end
        def self.from_product
          all
        end
        # endfor order_item_attribute 
      end
    end
  end
end end end