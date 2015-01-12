module Shoperb module Theme module Liquid module Drop
  class Search < Base

    def initialize(word = "")
    end

    def paginate(page = 1, search_size = 25)
      self
    end

    def results
      res = @record.try(:results) || []
    end

    alias_method :collection, :results
    delegate :any?, to: :results
    delegate :each, to: :results
    delegate :map, to: :results

    def inspect
      to_s
    end

  end
end end end end
