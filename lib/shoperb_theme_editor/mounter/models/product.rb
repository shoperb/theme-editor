module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Product < Base

        fields :id, :name, :description, :has_options, :permalink,
          :handle, :state, :translations, :template, :collection_ids,
          :category_id, :minimum_price, :maximum_price, :minimum_discount_price,
          :maximum_discount_price, :minimum_active_price, :maximum_active_price

        translates :name, :description

        attr_accessor :customer

        def self.active
          all.select(&:active?)
        end

        def self.by_name(dir)
          sort_by(&:name)
        end

        def self.by_price(dir)
          sort_by(&:minimum_price)
        end

        def self.by_created(dir)
          sort_by(&:created_at)
        end

        def self.by_updated(dir)
          sort_by(&:updated_at)
        end

        def active?
          state == "active"
        end

        def collections
          Collection.all.select { |collection| collection_ids.to_a.include?(collection.attributes[:id]) }
        end

        belongs_to :product_type
        alias_method :type, :product_type

        belongs_to :category

        belongs_to :vendor

        has_many :variants

        has_many :product_attributes

        def images
          Image.all.select { |image| image.entity == self }
        end

        def image
          images.first
        end

        def available?
          variants.any? { |o| o.available? }
        end

        def minimum_active_price
          variants.min { |a, b| a.active_price <=> b.active_price }.try(:active_price)
        end

        def similar
          category.products if category
        end

      end
    end
  end
end end end
