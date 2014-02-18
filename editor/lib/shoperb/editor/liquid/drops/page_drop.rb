class PageDrop < Liquid::Drop

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

  def content
    record.content
  end

  def url
    # TODO: Url Helper
    # @context.registers[:controller].send(:store_page_path, record)
    record.name
  end

  def to_s
    "#<Page name: '#{name}'>"
  end

  def inspect
    to_s
  end

end