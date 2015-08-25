module Shoperb module Theme module Liquid module Drop
  class Category < Base

    def initialize(record)
      @record = record || model(self.class).new
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
      record.root.try(:to_liquid, @context)
    end

    def root?
      record.root?
    end

    def descends_from(other)
      record.descends_from(other)
    end

    def parents
      Categories.new(record.ancestors).tap do |drop|
        drop.context = @context
      end
    end

    def children
      Categories.new(record.children).tap do |drop|
        drop.context = @context
      end
    end

    def children?
      record.children.any?
    end

    def products
      Products.new(record.products).tap do |drop|
        drop.context = @context
      end
    end

    def products_with_children
      Products.new(record.products_for_self_and_children).tap do |drop|
        drop.context = @context
      end
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
end end end end
