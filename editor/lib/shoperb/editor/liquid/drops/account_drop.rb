class AccountDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def shops
    CollectionDrop.new(@record.shops)
  end

end