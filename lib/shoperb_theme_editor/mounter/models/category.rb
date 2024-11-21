module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Category < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel


        fields :id, :parent_id, :state, :name, :permalink, :description,
          :lft, :rgt, :handle, :translations

        translates :name, :description
        fields :level

        def self.primary_key
          :id
        end

        dataset_module do
          def roots
            as_dataset(sorted.to_a.select(&:root?))
          end

          def active
            as_dataset(to_a.select(&:active?))
          end
        end

        has_many :products

        def parent
          Category.active.detect { |parent| parent.attributes[:id] == self.parent_id }
        end

        def children
          Category.active.where(parent_id: id)
        end

        def ancestors
          as_dataset(self_and_ancestors.to_a.reject { |category| category.id == id })
        end

        def self.sorted
          sort_by { |root| root.lft }
        end


        def self.active_roots
          roots.select(&:active?)
        end

        def root
          ancestors.last || self
        end

        def root?
          parent_id.nil?
        end

        def active?
          state == "active"
        end

        def products_with_children
          ids = products.map(&:id) | children.map(&:products_with_children).flatten.map(&:id)
          Product.where(id: ids)
        end

        def products_for_self_and_children
          arr = self_and_descendants.map(&:id)
          Product.where(id: Product.active.to_a.select { |product| arr.include?(product.category_id) }.map(&:id))
        end

        def descends_from(category)
          self_and_ancestors.include?(category)
        end

        def self_and_ancestors
          as_dataset(Category.active.to_a.select { |category| category.lft.to_i <= lft.to_i && category.rgt.to_i >= rgt.to_i })
        end

        def self_and_descendants
          Category.active.to_a.select do |category|
            category.ancestors.include?(self) || category.id == id
          end
        end

        def images
          Image.all.select { |image| image.entity == self }
        end

        def image
          images.first
        end

      end
    end
  end
end end end
