module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Collection < Base

        fields :id, :name, :permalink, :slug, :product_ids

        translates :name

        def self.primary_key
          :slug
        end

        def products
          Product.all.select { |product| product_ids.to_a.include?(product.attributes[:id]) }
        end

        def to_liquid context=nil
          Liquid::Drop::ProductCollection.new(self).tap do |drop|
            drop.context = context if context
          end
        end

      end
    end
  end
end end end
