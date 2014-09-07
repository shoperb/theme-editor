module Shoperb
  module Mounter
    module Model
      class Shop < Abstract::SingletonBase
        belongs_to :currency
        belongs_to :language

        def possible_languages
          Language.all.map(&:code)
        end

        def currency_with_check
          currency_without_check || raise(Error.new("Shops currency has not been set"))
        end
        alias_method_chain :currency, :check

      end
    end
  end
end