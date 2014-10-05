module Shoperb
  module Mounter
    module Model
      class Product < Base

        fields :name, :description, :has_options, :permalink, :slug, :state, :translations, :template

        def self.primary_key
          :slug
        end

        belongs_to :product_type
        alias_method :type, :product_type

        belongs_to :category

        belongs_to :vendor

        belongs_to :category

      end
    end
  end
end

