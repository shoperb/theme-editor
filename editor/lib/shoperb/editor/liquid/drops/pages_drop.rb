class PagesDrop < CollectionDrop

  private

  def handle_method
    :permalink
  end

  def collection
    if @collection.empty?
      @collection = Page.all
    end
    @collection
  end

end