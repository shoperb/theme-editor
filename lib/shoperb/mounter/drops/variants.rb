module Shoperb
  module Mounter
    module Drop
      class Variants < Collection
        def order_by_price
          collection
        end

        def order_by_sku
          collection
        end
      end
    end
  end
end