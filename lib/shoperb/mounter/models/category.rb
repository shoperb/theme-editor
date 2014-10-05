module Shoperb
  module Mounter
    module Model
      class Category < Base

        fields :parent_id, :state, :name, :permalink, :description, :lft, :rgt, :slug, :translations
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
          current = self
          [].tap { |a| a << (current = current.parent) until current.parent.nil? }
        end

        def self.roots
          all.select(&:root?)
        end

        def root
          ancestors.last
        end

        def root?
          !parent
        end

        def products_with_children
          products | children.map(&:products_with_children).flatten
        end

        def products_for_self_and_children
          arr = self_and_descendants
          Product.all.select { |product| arr.include?(product.category) }
        end

        def descends_from(category)
          self_and_ancestors.include?(category)
        end

        def self_and_ancestors
          [self] | ancestors
        end

        def self_and_descendants
          [self] | Category.all.select { |category| category.ancestors.include?(self) }
        end

      end
    end
  end
end

