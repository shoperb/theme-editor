class ProductCollectionDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def id
    record.id
  end

  def name
    record.name
  end

  def handle
    record.permalink
  end

  def url
    @context.registers[:controller].send(:store_collection_path, record)
  end

  def products
    ProductsDrop.new(record.products)
  end

  def to_s
    "#<ProductCollection name: '#{name}'>"
  end

  def inspect
    to_s
  end

end