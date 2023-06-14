module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Collection < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :name, :permalink, :handle, :image_id, :description
        c_fields :product_ids, cast: Array

        translates :name

        def self.primary_key
          :permalink
        end

        def products
          Product.active.select { |product| product_ids.to_a.include?(product.attributes[:id]) }
        end

        def vendors
          Vendor.where(id: products.map(&:vendor).uniq.compact.map(&:id) )
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
