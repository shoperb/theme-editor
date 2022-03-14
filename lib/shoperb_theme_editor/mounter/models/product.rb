module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Product < Base

        fields :id, :name, :description, :has_options, :permalink,
          :handle, :state, :translations, :template, :collection_ids,
          :category_id, :minimum_discount_price,
          :maximum_discount_price, :minimum_active_price,
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

        def self.by_product_type(dir)
          sort_by{|pr| pr.product_type&.name.to_s }
        end

        def self.by_tags(dir)
          sort_by{|pr| pr.grouping_tags.to_s }
        end

        def self.by_sku(dir)
          sort_by{|pr| pr.variants[0]&.sku.to_s }
        end

        def self.by_handle(dir)
          sort_by{|pr| pr.handle.to_s }
        end

        def self.find_by_sku(sku)
          if sku.respond_to?(:to_ary)
            all.select{|pr| sku.include?(pr.sku}
          else
            all.find{|pr| sku == pr.sku}
          end
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
        def maximum_active_price
          variants.max { |a, b| a.active_price <=> b.active_price }.try(:active_price)
        end
        def minimum_price
          variants.min { |a, b| a.price <=> b.price }.try(:price)
        end
        def maximum_price
          variants.max { |a, b| a.price <=> b.price }.try(:price)
        end

        def similar
          category.products if category
        end
        def related_products
          Product.all.select{|pr| related_ids.to_a.include?(pr.id)}
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
