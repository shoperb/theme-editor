class SearchDrop < Liquid::DelegateDrop

  def initialize *args
    @record = Search.instance
  end
end