class IgnoringArray < Array
  def method_missing(name, *args, &block)
    IgnoringArray.new(self)
  end

  def total_count
    count
  end

  def num_pages
    [0,1,2,3,4,5].sample
  end
end