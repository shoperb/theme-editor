module Shoperb
  module Mounter
    module Model
      class Product < Base

        fields :id, :name, :description, :has_options, :permalink, :slug, :state, :translations, :template, :collection_ids

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

        has_many :variants

        has_many :images

        has_many :product_attributes

        def image
          images.first
        end

        def available?
          variants.any? { |o| o.available? }
        end

        def minimum_active_price
          variants.min { |a, b| a.active_price <=> b.active_price }.try(:active_price)
        end

      end
    end
  end
end

