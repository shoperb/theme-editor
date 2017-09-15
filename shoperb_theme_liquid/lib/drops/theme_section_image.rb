module Shoperb module Theme module Liquid module Drop
  class ThemeSectionImage < Image
    def to_s
      record.url
    end
  end
end
