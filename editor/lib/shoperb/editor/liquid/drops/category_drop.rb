class CategoryDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record || Category.new
  end

  def id
    record.id
  end

  def name
    record.name
  end

  def handle
    record.permalink
  end

  def parent
    record.parent
  end

  def level
    record.level
  end
  
  def url
    record.id ? @context.registers[:controller].send(:store_category_path, record) : ""
  end

  def root
    CategoryDrop.new(record.root)
  end

  def root?
    record.root?
  end

  def current?
    record == current
  end

  def open?
    current && current.descends_from(record)
  end

  def descends_from(other)
    record.descends_from(other)
  end

  def parents
    CategoriesDrop.new(record.ancestors)
  end

  def children
    CategoriesDrop.new(record.children)
  end

  def products
    ProductsDrop.new(record.products)
  end

  def products_with_children
    ProductsDrop.new(record.products_for_self_and_children)
  end

  def to_s
    "#<Category name: '#{record.name}'>"
  end

  def inspect
    to_s
  end

  private

  def current
    @current ||= @context.registers[:controller].instance_variable_get("@category")
  end

end