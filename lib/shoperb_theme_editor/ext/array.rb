class Array
  def exists?
    size>0
  end

  def sorted
    if first.respond_to?(:id)
      self.sort_by(&:id)
    else
      self
    end
  end
end
