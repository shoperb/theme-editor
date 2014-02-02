class CurrencyDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def name
    record.name
  end

  def code
    record.code
  end

  def symbol
    record.symbol
  end

  def inspect
    "#<Currency code: '#{record.code}'>"
  end

  def to_s
    inspect
  end

end