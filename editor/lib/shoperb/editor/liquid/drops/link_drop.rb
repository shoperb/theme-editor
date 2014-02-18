class LinkDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def id
    record.id
  end

  def url
    case record.style
      when Link::STYLE_CUSTOM
        record.value
      when Link::STYLE_HOME
        # TODO: Url Helper
        # @context.registers[:controller].send(:store_root_path)
        "/"
      when Link::STYLE_SEARCH
        # TODO: Url Helper
        # @context.registers[:controller].send(:store_search_path)
        "/search"
      when Link::STYLE_PAGE
        "/#{record.entity.to_param}"
      else
        # TODO: Url Helper
        # @context.registers[:controller].send("store_#{record.style.downcase}_path", record.entity)
        record.entity.to_s.underscore
    end
  end

  def menu
    record.menu
  end

  def name
    record.name
  end

  def handle
    record.handle
  end

  def object?
    !record.entity.nil?
  end

  def object
    record.entity
  end

  def to_s
    "#<Link name: '#{name}'>"
  end

  def inspect
    to_s
  end

end