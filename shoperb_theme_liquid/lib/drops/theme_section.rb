module Shoperb module Theme module Liquid module Drop
  class ThemeSection < Base

    attr_reader :record

    def initialize(id, section)
      @id = id
      @record = section || {}
    end

    def id
      @id
    end

    def blocks
      ThemeSectionBlocks.new(record['blocks'], record['block_order'])
    end

    def block_order
      record['block_order']
    end

    def settings
      ThemeSectionSettings.new(record)
    end

    # for blocks
    def type
      record['type']
    end
  end
end end end end
