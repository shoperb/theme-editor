class CartItemDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def id
    record.id
  end

  def sku
    record.sku
  end

  def name
    record.variant.name
  end

  def quantity
    record.amount
  end

  def stock
    record.stock
  end

  def weight
    record.variant.weight
  end

  def price
    record.variant.price
  end

  def discount_price
    record.variant.price_discount
  end

  def active_price
    record.variant.active_price
  end

  def discount?
    record.variant.discount_active?
  end

  def discount_start
    record.variant.formatted_discount_start
  end

  def discount_end
    record.variant.formatted_discount_end
  end

  def total
    record.total
  end

  def total_weight
    record.weight
  end

  def requires_taxing?
    record.variant.charge_taxes?
  end

  def requires_shipping?
    record.variant.require_shipping?
  end

  def vendor
    VendorDrop.new(record.vendor)
  end

  def type
    ProductTypeDrop.new(record.product.product_type)
  end

  def product
    ProductDrop.new(record.product)
  end

  def variant
    VariantDrop.new(record.variant)
  end

  def to_s
    "#<CartItem name: '#{record.variant.name}'>"
  end

  def inspect
    to_s
  end

end