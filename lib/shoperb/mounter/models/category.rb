module Shoperb
  module Mounter
    module Model
      class Category < Abstract::Base
        has_many :products

        def children
          DelegateArray.new(Category.all.select { |category| category.parent == self })
        end

        def children?
          children.any?
        end

        def parent
          Category.all.detect { |category| category.name == self.parent_name }
        end

        def parents
          current = self
          DelegateArray.new.tap { |a| a << (current = current.parent) until current.parent.nil? }
        end

        def roots
          DelegateArray.new(Category.all.select(&:root?))
        end

        def root?
          !parent
        end

        def products_with_children
          products | children.map(&:products_with_children).flatten
        end
      end
    end
  end
end

