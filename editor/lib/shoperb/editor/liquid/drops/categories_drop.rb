require 'shoperb/editor/liquid/drops/collection_drop'
class CategoriesDrop < CollectionDrop

  def initialize(collection = nil)
    @collection = collection
  end

  def roots
    CategoriesDrop.new(Category.active.roots)
  end

  def handle_method
    :permalink
  end

end