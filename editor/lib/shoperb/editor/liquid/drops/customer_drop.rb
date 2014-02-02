class CustomerDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def name
    record.name
  end

  def first_name
    record.first_name
  end

  def last_name
    record.last_name
  end

  def email
    record.email
  end

  def accepts_newsletter?
    record.newsletter
  end

  def registred?
    record.active?
  end

  def last_billing_address
    AddressDrop.new(record.last_bill_address)
  end

  def last_shipping_address
    AddressDrop.new(record.last_ship_address)
  end

  def addresses
    CollectionDrop.new(record.addresses)
  end

  def to_s
    inspect
  end

  def inspect
    "#<Customer name: '#{record.name}'>"
  end

end