module Shoperb module Theme module Liquid module Drop
  class Vendor < Base

    def initialize(record)
      @record = record || model(self.class).new({})
    end

    def id
      record.id
    end

    def name
      record.name
    end

  end
end end end end
