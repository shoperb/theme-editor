module Shoperb
  module Mounter
    module Drop
      class Cart < Base

        def total
          record.total
        end

        def weight
          record.weight
        end

        def quantity
          record.items.sum(&:amount)
        end

        def requires_shipping?
          record.require_shippable?
        end

        def items
          Collection.new(record.items)
        end

      end
    end
  end
end
