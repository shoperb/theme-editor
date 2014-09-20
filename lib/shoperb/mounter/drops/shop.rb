module Shoperb
  module Mounter
    module Drop
      class Shop < Delegate

        def current?
          true
        end

        def address
          __to_drop__ Drop::Address, :address
        end

        def language
          __to_drop__ Drop::Language, :language
        end

        def current_locale
          Filter::Translate.locale
        end

        def currency
          __to_drop__ Drop::Currency, :currency
        end

        def account
          __to_drop__ Drop::Account, :account
        end

      end
    end
  end
end