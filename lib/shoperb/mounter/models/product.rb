module Shoperb
  module Mounter
    module Model
      class Product < Base

        fields :name, :description, :has_options, :permalink, :slug, :state, :translations, :template, :collection_ids

        def self.primary_key
          :slug
        end

        def collections
          Collection.all.select { |collection| collection_ids.to_a.include?(collection.attributes[:id]) }
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

