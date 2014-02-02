class OrderDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def name
    "#" + record.order_number
  end

  def number
    record.order_number
  end

  def email
    record.email
  end

  def total
    record.total
  end

  def subtotal
    record.total_items
  end

  def total_shipping
    record.total_shipping
  end

  def total_taxes
    record.total_taxes
  end

  def requires_shipping?
    record.require_shipping?
  end

  def requires_taxation?
    record.require_taxation?
  end

  def created_at
    record.created_at
  end

  # TODO: tax lines
  # TODO: shipping method
  # TODO: payment method

  def billing_address
    AddressDrop.new(record.bill_address)
  end

  def shipping_address
    AddressDrop.new(record.ship_address)
  end

  def items
    CollectionDrop.new(record.items)
  end

  def customer
    CustomerDrop.new(record.customer)
  end

  def currency
    CurrencyDrop.new(record.currency)
  end

  def inspect
    "#<Order #{record.order_number}>"
  end

  def to_s
    inspect
  end

end