class IgnoringArray < Array
  def method_missing(name, *args, &block)
    self
  end
end