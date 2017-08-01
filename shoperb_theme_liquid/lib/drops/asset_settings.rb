module Shoperb module Theme module Liquid module Drop
  class AssetSettings < Settings

    private

    #
    # adding a setting key around value in a comment
    #
    def format_value(key, value)
      "'/*settings.#{key}[*/#{value}/*]*/'"
    end
  end
end end end end