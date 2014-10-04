module Shoperb
  module Mounter
    module Model
      class Category < Base

        fields :id, :parent_id, :state, :name, :permalink, :description, :lft, :rgt, :slug, :translations

        def self.primary_key
          :slug
        end

        has_many :products

      end
    end
  end
end

