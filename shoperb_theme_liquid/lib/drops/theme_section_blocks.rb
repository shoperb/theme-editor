module Shoperb module Theme module Liquid module Drop
  class ThemeSectionBlocks < Collection

    def initialize(collection = nil, order = nil)
      @collection = collection || []
      @order = order || []
    end

    def each
      order.each do |id|
        yield ThemeSection.new(id, collection[id])
      end
    end
  end
end end end end
