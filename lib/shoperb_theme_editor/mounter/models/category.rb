module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Category < Base

        fields :id, :parent_id, :state, :name, :permalink, :description, :lft, :rgt, :handle, :translations
        translates :name, :description
        fields :level

        def self.primary_key
          :permalink
        end

        has_many :products

        def parent
          Category.active.detect { |parent| parent.attributes[:id] == self.parent_id }
        end

        def children
          Category.active.select { |child| child.parent_id == attributes[:id] }
        end

        def ancestors
          self_and_ancestors - [self]
        end

        def self.sorted
          all.sort_by { |root| root.lft }
        end

        def self.roots
          sorted.select(&:root?)
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

        def self.active
          all.select(&:active?)
        end

        def active?
          state == "active"
        end

        def products_with_children
          products | children.map(&:products_with_children).flatten
        end

        def products_for_self_and_children
          arr = self_and_descendants.map(&:id)
          Product.active.select { |product| arr.include?(product.category_permalink) }
        end

        def descends_from(category)
          self_and_ancestors.include?(category)
        end

        def self_and_ancestors
          self.class.active.select { |category| category.lft <= lft && category.rgt >= rgt }
        end

        def self_and_descendants
          [self] | Category.active.select { |category| category.ancestors.include?(self) }
        end

      end
    end
  end
end end end
