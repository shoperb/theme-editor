class ProductsDrop < CollectionDrop

  def initialize(collection = nil)
    @collection = collection.active.preload(:product_attributes, :variants)
  end

  def before_method(method, *args)
    if matches = method.match(/order_by_(.*)_(asc|desc)/i)
      @collection = case matches[1]
        when "created"
          collection.by_created(matches[2])
        when "name"
          collection.by_name(matches[2])
        when "price"
          collection.by_price(matches[2])
        else
          collection
      end and self
    else
      super(method)
    end
  end

  def handle_method
    :permalink
  end

end