module Shoperb module Theme module Liquid module Drop
  class Section < Base

    def settings
      SectionSettings.new(@record)
    end
  end
end end end end
