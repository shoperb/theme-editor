class CartDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def total
    record.total
  end

  def weight
    record.weight
  end

  def quantity
    record.items.sum(&:amount)
  end

  def requires_shipping?
    record.require_shippable?
  end

  def items
    CollectionDrop.new(record.items)
  end

  def to_s
    "#<Cart token: '#{record.token}'>"
  end

  def inspect
    to_s
  end

end