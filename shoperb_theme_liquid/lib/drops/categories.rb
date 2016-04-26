module Shoperb module Theme module Liquid module Drop
  class Categories < Collection
    def roots
      Categories.new(model(Category).active_roots).tap do |drop|
        drop.context = @context
      end
    end

    def handle_method
      :permalink
    end
  end
end end end end

