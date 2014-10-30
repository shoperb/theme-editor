module Shoperb
  module Mounter
    module Model
      class Category < Base

        fields :id, :parent_id, :state, :name, :permalink, :description, :lft, :rgt, :slug, :translations
        fields :level

        def self.primary_key
          :slug
        end

        has_many :products

        def parent
          Category.all.detect { |parent| parent.attributes[:id] == self.parent_id }
        end

        def children
          Category.all.select { |child| child.parent_id == attributes[:id] }
        end

        def ancestors
          self_and_ancestors - [self]
        end

        def self.roots
          all.select(&:root?)
        end

        def root
          ancestors.last
        end

        def root?
          parent_id.nil?
        end

        def products_with_children
          products | children.map(&:products_with_children).flatten
        end

        def products_for_self_and_children
          arr = self_and_descendants.map(&:slug)
          Product.all.select { |product| arr.include?(product.category_slug) }
        end

        def descends_from(category)
          self_and_ancestors.include?(category)
        end

        def self_and_ancestors
          self.class.all.select { |category| category.lft <= lft && category.rgt >= rgt }
        end

        def self_and_descendants
          [self] | Category.all.select { |category| category.ancestors.include?(self) }
        end

      end
    end
  end
end

