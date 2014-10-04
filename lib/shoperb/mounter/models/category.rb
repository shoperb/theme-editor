module Shoperb
  module Mounter
    module Model
      class Category < Base

        fields :id, :parent_id, :state, :name, :permalink, :description, :lft, :rgt, :slug, :translations

        def self.primary_key
          :slug
        end

        has_many :products

        # def children
        #   Category.all.select { |category| category.parent == self }
        # end
        #
        # def children?
        #   children.any?
        # end
        #
        # def parent
        #   Category.all.detect { |category| category.name == self.parent_name }
        # end
        #
        # def parents
        #   current = self
        #   [].tap { |a| a << (current = current.parent) until current.parent.nil? }
        # end
        #
        # def self.roots
        #   Category.all.select(&:root?)
        # end
        #
        # def root?
        #   !parent
        # end
        #
        # def products_with_children
        #   products | children.map(&:products_with_children).flatten
        # end
      end
    end
  end
end

