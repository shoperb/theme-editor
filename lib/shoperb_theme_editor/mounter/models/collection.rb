module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Collection < Base

        fields :id, :name, :permalink, :slug, :translations, :product_ids

        def self.primary_key
          :slug
        end

        def products
          Product.all.select { |product| product_ids.to_a.include?(product.attributes[:id]) }
        end

      end
    end
  end
end end end
