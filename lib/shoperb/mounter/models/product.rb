module Shoperb
  module Mounter
    module Model
      class Product < Base
        fields :id, :name, :description, :has_options, :permalink, :slug, :state, :category_id, :vendor_id, :product_type_id, :translations, :template, :product_type_handle, :category_slug

        def self.primary_key
          :slug
        end

        belongs_to :vendor
        belongs_to :category
        belongs_to :product_type
        has_many :variants
        has_many :images
        has_many :product_attributes

        def image
          images.first
        end

        def others_in_category
          category.try(:products_with_children) || []
        end
      end
    end
  end
end

