class OrderItemDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def name
    record.name
  end

  def quantity
    record.amount
  end

  def sku
    record.sku
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

  def price
    record.price
  end

  def subtotal
    record.total_without_taxes
  end

  def total
    record.total
  end

  def total_weight
    record.total_weight
  end

  def total_taxes
    record.total_taxes
  end

  def requires_shipping?
    record.require_shipping?
  end

  def requires_taxation?
    record.charge_taxes?
  end

  def inspect
    "#<OrderItem name: '#{record.name}'>"
  end

  def to_s
    inspect
  end

end