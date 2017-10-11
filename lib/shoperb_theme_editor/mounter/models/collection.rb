module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Collection < Base

        fields :id, :name, :permalink, :handle, :product_ids, :image_id

        translates :name

        def self.primary_key
          :handle
        end

        def products
          Product.active.select { |product| product_ids.to_a.include?(product.attributes[:id]) }
        end

        def images
          Image.all.select { |image| image.entity == self }
        end

        def image
          images.first
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
