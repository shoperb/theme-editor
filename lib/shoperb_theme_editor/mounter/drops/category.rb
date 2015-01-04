module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Category < Base

        attr_reader :record

        def initialize(record)
          @record = record || Model::Category.new
        end

        def id
          record.id
        end

        def name
          record.name
        end

        def handle
          record.permalink
        end

        def parent
          record.parent
        end

        def level
          record.level
        end

        def url
          default_url
        end

        def root
          Category.new(record.root)
        end

        def root?
          record.root?
        end

        def descends_from(other)
          record.descends_from(other)
        end

        def parents
          Categories.new(record.ancestors)
        end

        def children
          Categories.new(record.children)
        end

        def children?
          record.children.any?
        end

        def products
          Products.new(record.products)
        end

        def products_with_children
          Products.new(record.products_for_self_and_children)
        end

        def to_s
          "#<Category name: '#{record.name}'>"
        end

        def inspect
          to_s
        end

        def current?
          record == current
        end

        def open?
          current && current.descends_from(record)
        end

        private

        def current
          @context.registers[:category]
        end

      end
    end
  end
end end end
