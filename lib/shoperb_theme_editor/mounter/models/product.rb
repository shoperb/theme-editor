module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Product < Base

        fields :id, :name, :description, :has_options, :permalink,
          :handle, :state, :translations, :template, :collection_ids,
          :category_id, :minimum_price, :maximum_price, :minimum_discount_price,
          :maximum_discount_price, :minimum_active_price, :maximum_active_price,
          :grouping_tags, :dirty_variant_attributes, :related_ids

        translates :name, :description

        attr_accessor :customer

        def self.primary_key
          :id
        end

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
          sort_by(&:id)
        end

        def self.by_updated(dir)
          sort_by(&:id)
        end

        def active?
          state == "active"
        end

        def reviewable?(customer)
          true
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

        has_many :reviews

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
        def related_products
          Product.all.select{|pr| related_ids.include?(pr.id)}
        end

        def rating
          count = reviews.visible.count
          sum   = reviews.visible.reduce(0) do |memo, item|
            memo += item.rating
            memo
          end

          if count == 0
            return 0
          end

          return sum / count
        end

      end
    end
  end
end end end
