class CollectionDrop < Liquid::Drop

  attr_reader :collection

  def initialize(collection = nil)
    @collection = IgnoringArray.new(collection || [])
  end

  def before_method(method)
    collection.detect { |o| o.try(handle_method.to_sym) == method.to_s }
  end

  def each
    limited.each do |item|
      yield item.to_liquid
    end
  end

  def count
    collection.count
  end

  def any?
    collection.any?
  end

  def many?
    collection.many?
  end

  def one?
    collection.one?
  end

  def empty?
    collection.empty?
  end

  def first
    collection.first.to_liquid
  end

  def last
    collection.last.to_liquid
  end

  def to_a
    limited.map { |o| o.to_liquid }
  end

  def to_s
    "#<Collection size: #{count}, items: #{to_a}>"
  end

  def inspect
    to_s
  end

  private

  def paginate(page, per_page)
    self.class.new(collection.page(page).per(per_page))
  end

  def limit_value
    (collection.respond_to?(:limit_value) && collection.limit_value) || 50
  end

  def limited
    (collection.respond_to?(:limit) && collection.limit(limit_value)) || collection.slice(0..limit_value)
  end

  def handle_method
    :handle
  end

end