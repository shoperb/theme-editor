class CollectionDrop < Liquid::DelegateDrop

  attr_reader :collection

  def initialize(collection = nil)
    @collection = DelegateArray.new(collection || [])
  end

  def method_missing name, *args, &block
    @collection.respond_to?(name) ? @collection.send(name, *args, &block) : super
  end

  def each
    limited.each do |item|
      yield item.to_liquid
    end
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

  def inspect
    "<#{self.class.to_s} #{@collection.inspect} >"
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

end