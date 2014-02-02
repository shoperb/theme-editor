class VendorDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record || Vendor.new
  end

  def id
    record.id
  end

  def name
    record.name
  end

  def to_s
    "#<Vendor name: '#{record.name}'>"
  end

  def inspect
    to_s
  end

end