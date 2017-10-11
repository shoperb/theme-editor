module Shoperb module Theme module Liquid module Drop
  class Variants < Collection

    def order_by_price
      collection.sort_by(&:active_price)
    end

    def order_by_sku
      collection.sort_by(&:sku)
    end
  end
end end end end

