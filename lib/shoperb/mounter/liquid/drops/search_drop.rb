class SearchDrop < Liquid::DelegateDrop

  def initialize *args
    @record = Shoperb::Mounter::Models::Search.instance
  end
end