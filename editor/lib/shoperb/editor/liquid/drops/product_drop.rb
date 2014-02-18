class ProductDrop < Liquid::Drop

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
    # TODO: Url Helper
    #@context.registers[:controller].send(:store_product_path, record)
    "product"
  end

  def max_price
    record.maximum_price
  end

  def min_price
    record.minimum_price
  end
  alias :price :min_price

  def min_discount_price
    record.minimum_discount_price
  end

  def max_discount_price
    record.maximum_discount_price
  end

  def min_active_price
    record.minimum_active_price
  end

  def max_active_price
    record.maximum_active_price
  end

  def available?
    record.available?
  end

  def description
    record.description
  end

  def options
    record.product_attributes.map(&:value)
  end

  def category
    CategoryDrop.new(record.category)
  end

  def vendor
    VendorDrop.new(record.vendor)
  end

  def type
    ProductTypeDrop.new(record.product_type)
  end

  def variants
    VariantsDrop.new(record.variants)
  end

  def image
    ImageDrop.new(record.image) if record.image
  end

  def images
    CollectionDrop.new(record.images.sorted)
  end

  def attributes
    CollectionDrop.new(record.product_attributes)
  end

  def variant_properties
    CollectionDrop.new(record.variant_attributes)
  end

  def to_s
    "#<Product name: '#{record.name}'>"
  end

  def inspect
    to_s
  end

end