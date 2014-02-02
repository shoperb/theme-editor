class AddressDrop < Liquid::Drop

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

  def company
    record.company
  end

  def email
    record.email
  end

  def phone
    record.phone
  end

  def street
    record.full_address
  end

  def address1
    record.address1
  end

  def address2
    record.address2
  end

  def city
    record.city
  end

  def state
    record.state_name
  end

  def country
    record.country_name
  end

  def inspect
    "#<Address>"
  end

  def to_s
    inspect
  end

end