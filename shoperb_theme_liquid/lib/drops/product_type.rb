module Shoperb module Theme module Liquid module Drop
  class ProductType < Base

    def id
      record.try(:id)
    end

    def name
      record.try(:name)
    end

    def handle
      record.try(:handle)
    end

  end
end end end end
