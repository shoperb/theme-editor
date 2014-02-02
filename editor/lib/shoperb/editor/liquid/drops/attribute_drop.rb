class AttributeDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def id
    record.id
  end

  def handle
    record.handle
  end

  def name
    record.name
  end

  def value
    record.value
  end

  def to_s
    "#<Attribute name: '#{name}'>"
  end

end