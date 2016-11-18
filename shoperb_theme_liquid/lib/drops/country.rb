module Shoperb module Theme module Liquid module Drop
  class Country < Base

    def id
      record.id
    end

    def code
      record.code
    end

    def name
      record.name
    end
    def iso3
      record.iso3
    end
    def numeric
      record.numeric
    end
    def eu
      record.eu
    end
    def na
      record.na
    end
    def abstract
      record.abstract
    end

  end
end end end end
