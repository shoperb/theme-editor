class MenusDrop < CollectionDrop

  def links
    CollectionDrop.new(Link.all)
  end

  private

  def collection
    if @collection.empty?
      @collection = Menu.all
    end
    @collection
  end

end