module Shoperb module Theme module Liquid module Drop
  class Pages < Collection

    private

    def handle_method
      :permalink
    end

    def collection
      if @collection.empty?
        @collection = model(Page).all
      end
      @collection
    end

  end
end end end end
