class MetaDrop < Liquid::DelegateDrop
  def method_missing name, *args, &block
    @record.send(name, *args, &block) if @record
  end
end