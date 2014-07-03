class DelegateArray < Array
  def method_missing(name, *args, &block)
    class_eval do
      define_method name do |*args, &block|
        DelegateArray.new(self)
      end
    end
    send(name, *args, &block)
  end

  def total_count
    count
  end

  def num_pages
    [0, 1, 2, 3, 4, 5].sample
  end

  def inspect
    "DA#{super}"
  end
end