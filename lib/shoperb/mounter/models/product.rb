module Shoperb
  module Mounter
    module Model
      class Product < Base

        fields :id, :name, :description, :has_options, :permalink, :slug, :state, :category_id, :vendor_id, :product_type_id, :translations, :template, :product_type_handle, :category_slug

        def self.primary_key
          :slug
        end

      end
    end
  end
end

