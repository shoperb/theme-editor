module Shoperb module Theme module Liquid module Drop
  class Vendors < Collection

    def not_empty
      self.class.new(collection.select { |c| c.products.size > 0 })
    end
  end
end end end end

