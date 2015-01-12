module Shoperb module Theme module Liquid module Drop
  class ProductCollections < Collection

    private

    def collection
      if @collection.empty?
        @collection = model("Collection").all
      end
      @collection
    end

    def handle_method
      :slug
    end

  end
end end end end
