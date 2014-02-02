class ProductTypeDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record || ProductType.new
  end

  def id
    record.id
  end

  def name
    record.name
  end

  def handle
    record.handle
  end

  def to_s
    "#<ProductType name: '#{record.name}'>"
  end

  def inspect
    to_s
  end

end