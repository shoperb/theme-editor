module Shoperb module Theme module Liquid module Drop
  class Attribute < Base

    def id
      record.id
    end

    def handle
      record.handle
    end

    def name
      record.name
    end

    def value
      record.value
    end

  end
end end end end
