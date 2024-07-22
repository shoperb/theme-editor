module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Product < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :name, :description, :has_options, :permalink,
          :handle, :state, :translations, :template, :collection_ids,
          :minimum_discount_price,
          :maximum_discount_price, :minimum_active_price
        c_fields :category_id, :vendor_id, :product_type_id, cast: Integer
        c_fields :dirty_variant_attributes, cast: JSON
        c_fields :grouping_tags, :related_ids, cast: JSON

        translates :name, :description

        attr_accessor :customer


        belongs_to :product_type
        alias_method :type, :product_type

        belongs_to :category

        belongs_to :vendor

        has_many :variants

        has_many :product_attributes

        has_many :reviews

        def self.primary_key
          :id
        end

        dataset_module do
          def active
            where(state: 'active')
          end

          def by_name(dir)
            as_dataset(sort_by(&:name))
          end
  
          def by_price(dir)
            sort_by(&:minimum_price)
          end
  
          def by_created(dir)
            sort_by(&:id)
          end
  
          def by_updated(dir)
            sort_by(&:id)
          end
  
          def by_product_type(dir)
            sort_by{|pr| pr.product_type&.name.to_s }
          end
  
          def by_tags(dir)
            sort_by{|pr| pr.grouping_tags.to_s }
          end
  
          def by_sku(dir)
            sort_by{|pr| pr.variants[0]&.sku.to_s }
          end
  
          def by_handle(dir)
            sort_by{|pr| pr.handle.to_s }
          end
        end

        

        def self.random
          all.sample
        end


        def active?
          state == "active"
        end

        def reviewable?(customer)
          true
        end

        def collections
          Collection.as_dataset(Collection.to_a.select { |collection| collection_ids.to_a.include?(collection.attributes[:id]) })
        end

        def images
          Image.for(self)
        end

        def image
          images.first
        end

        def available?
          variants.to_a.any? { |o| o.available? }
        end

        def minimum_active_price
          variants.to_a.min { |a, b| a.active_price <=> b.active_price }.try(:active_price)
        end
        def maximum_active_price
          variants.to_a.max { |a, b| a.active_price <=> b.active_price }.try(:active_price)
        end
        def minimum_price
          variants.to_a.min { |a, b| a.price <=> b.price }.try(:price)
        end
        def maximum_price
          variants.to_a.max { |a, b| a.price <=> b.price }.try(:price)
        end

        def similar
          category.products if category
        end
        def related_products
          as_dataset(Product.to_a.select{|pr| related_ids.to_a.include?(pr.id)})
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
