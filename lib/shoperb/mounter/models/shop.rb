module Shoperb
  module Mounter
    module Model
      class Shop < Abstract::SingletonBase
        belongs_to :currency
        belongs_to :language

        def possible_languages
          Language.all.map(&:code)
        end

      end
    end
  end
end