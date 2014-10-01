module Shoperb
  module Mounter
    module Drop
      class Collection < ::Liquid::Drop

        attr_reader :collection

        def initialize(collection = nil)
          @collection = collection
        end

        def before_method(method)
          collection.detect { |o| o.send(o.class.finder) == method.to_s }
        end

        def method_missing name, *args, &block
          collection.send(name)
        end

        delegate :each, to: :collection
        delegate :count, to: :collection
        delegate :any?, to: :collection
        delegate :many?, to: :collection
        delegate :one?, to: :collection
        delegate :empty?, to: :collection
        delegate :first, to: :collection
        delegate :last, to: :collection

        def inspect
          "<#{self.class.to_s} #{@collection.inspect} >"
        end

        def paginate(page, per_page)
          self.class.new(@collection.take(per_page.to_i))
        end
      end
    end
  end
end