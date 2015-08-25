module Shoperb module Theme module Liquid module Drop
  class ProductCollection < Base

    def id
      record.id
    end

    def name
      record.name
    end

    def handle
      record.permalink
    end

    def url
      default_url handle
    end

    def products
      Products.new(record.products).tap do |drop|
        drop.context = @context
      end
    end

  end
end end end end
