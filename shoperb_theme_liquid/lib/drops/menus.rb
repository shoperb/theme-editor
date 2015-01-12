module Shoperb module Theme module Liquid module Drop
  class Menus < Collection
    def links
      Collection.new(model(Link).all)
    end

    private

    def collection
      if @collection.empty?
        @collection = model(Menu).all
      end
      @collection
    end
  end
end end end end
