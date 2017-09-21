module Shoperb module Theme module Liquid module Drop
  class Collection < ::Liquid::Drop

    attr_reader :collection

    def initialize(collection = nil)
      @collection = collection || []
    end

    def before_method(method)
      collection.detect { |o| o.try(handle_method.to_sym) == method.to_s }
    end

    def each
      limited.each do |item|
        case arity = item.method(:to_liquid).arity
          when 0
            yield item.to_liquid
          else
            yield item.to_liquid(@context)
        end
      end
    end

    def count
      collection.count
    end

    def size
      collection.size
    end

    def any?
      collection.any?
    end

    def many?
      collection.many?
    end

    def one?
      collection.one?
    end

    def empty?
      collection.empty?
    end

    def first
      collection.first.try(:to_liquid, @context)
    end

    def last
      collection.last.try(:to_liquid, @context)
    end

    def to_a
      limited.map { |o| o.to_liquid(@context) }
    end

    private

    def limit_value
      (collection.respond_to?(:limit_value) && collection.limit_value) || 50
    end

    def limited
      (collection.respond_to?(:limit) && collection.limit(limit_value)) || collection.slice(0..limit_value)
    end

    def handle_method
      :handle
    end

    def models
      @context.registers[:models]
    end

    def model klass
      models.const_get(klass.to_s.demodulize)
    end

    def paginate(page, per_page)
      self.class.new(Kaminari::PaginatableArray.new(collection).page(page).per(per_page))
    end
  end
end end end end
