class OrderDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def name
    "#" + record.number
  end

  def number
    record.number
  end

  def token
    record.token
  end

  def email
    record.email
  end

  def total
    record.total
  end

  def subtotal
    record.subtotal
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


  def state
    record.state
  end


  # TODO: tax lines
  # TODO: shipping method

  def payment_method
    record.payment_method.to_liquid
  end

  def payment_method_name
    record.payment_method.name
  end

  def billing_address
    AddressDrop.new(record.bill_address)
  end

  def shipping_address?
    !!record.ship_address
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


  def url
    @context.registers[:controller].send(:store_order_path, number)
  end


  def inspect
    "#<Order #{record.number}>"
  end

  def to_s
    inspect
  end

end