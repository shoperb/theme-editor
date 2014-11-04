module Shoperb
  module Mounter
    module Model
      class Product < Abstract::Base
        has_and_belongs_to_many :collections
        belongs_to :vendor
        belongs_to :category
        belongs_to :product_type
        #has_many :variants
        has_many :images
        has_many :product_attributes

        def variants
          Drop::Delegate::Array.new(Model::Variant.all.select { |object| object.product_permalink == self.permalink })
        end

        def variants?
          variants.any?
        end

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

