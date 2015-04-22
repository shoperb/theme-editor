module Shoperb module Theme module Liquid module Drop
  class Array < Collection
    def [](attr)
      return super unless attr.is_a?(Integer)
      collection[attr]
    end

    def include?(other)
      collection.include?(other)
    end
  end
end end end end
