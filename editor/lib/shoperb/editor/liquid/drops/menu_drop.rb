class MenuDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
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

  def links
    CollectionDrop.new(record.links)
  end

  def to_s
    "#<Menu name: '#{name}', links: '#{record.links.count}'>"
  end

  def inspect
    to_s
  end

end