class LanguageDrop < Liquid::Drop

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

  def active?
    record.active?
  end

  def inspect
    "#<Language code: '#{record.code}'>"
  end

  def to_s
    inspect
  end

end