class VariantDrop < Liquid::Drop

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

  def price
    record.price
  end

  def discount_price
    record.price_discount
  end

  def discount?
    record.discount_active?
  end

  def discount_period?
    record.has_discount_range?
  end

  def discount_start
    record.formatted_discount_start
  end

  def discount_end
    record.formatted_discount_end
  end

  def current_price
    record.active_price
  end

  def available?
    record.available?
  end

  def sku
    record.sku
  end

  def stock
    record.track_inventory? ? record.stock : "&#8734;"
  end

  def weight
    record.weight
  end

  def width
    record.width
  end

  def height
    record.height
  end

  def depth
    record.depth
  end

  def options
    record.variant_attributes.map(&:value)
  end

  def image
    ImageDrop.new(record.image) if record.image
  end

  def images
    CollectionDrop.new(record.images.sorted)
  end

  def attributes
    CollectionDrop.new(record.variant_attributes)
  end

  def to_s
    "#<Variant SKU: '#{record.sku}'>"
  end

  def json
    h = record.as_json(only: [:id, :name, :weight, :width, :height, :depth]).merge(current_price: current_price, has_discount: discount?, discount_price: discount_price)
    record.variant_attributes.each do |attr|
      h[:attributes] = [] unless h[:attributes]
      h[:attributes] << {id: attr.id, name: attr.name, value: attr.value}
    end

    h.to_json
  end

  def inspect
    to_s
  end

end