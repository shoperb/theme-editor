class LinkDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def id
    record.id
  end

  def url
    controller = @context.registers[:controller]
    path       = "store_#{record.style.downcase}_path"

    case record.style
      when Link::STYLE_CUSTOM
        record.value
      when Link::STYLE_HOME
        controller.send(:store_root_path)
      when Link::STYLE_SEARCH
        controller.send(:store_search_path)
      else
        index_action? ? controller.send(path) : controller.send(path, record.entity)
    end
  end


  def index_action?
    s = record.style.downcase
    s == s.pluralize
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