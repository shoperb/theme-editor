module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Collection < Base

        fields :id, :name, :permalink, :handle, :product_ids, :image_id

        translates :name

        def products
          Product.active.select { |product| product_ids.to_a.include?(product.attributes[:id]) }
        end

        def vendors
          products.map(&:vendor).uniq.compact.to_relation(Vendor)
        end

        def images
          Image.all.select { |image| image.entity == self }
        end

        def image
          images.first
        end

        def to_liquid context=nil
          ShoperbLiquid::ProductCollectionDrop.new(self)
        end

      end
    end
  end
end end end
