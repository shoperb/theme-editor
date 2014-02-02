class ImageDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def width
    record.original_width || record.width
  end

  def height
    record.original_height || record.height
  end

  def url
    record.url
  end

  def before_method(method, *args)
    if image = record.image_sizes.detect { |s| s.name == method.to_s }
      ImageDrop.new(image)
    end
  end

  def to_s
    "#<Image name: '#{record.name}'>"
  end

  def inspect
    to_s
  end

end