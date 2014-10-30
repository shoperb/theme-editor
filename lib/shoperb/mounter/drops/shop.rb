module Shoperb
  module Mounter
    module Drop
      class Shop < Base

        def name
          record.name
        end

        def domain
          record.external_hostname
        end

        def meta_title
          record.meta_title
        end

        def meta_keywords
          record.meta_keywords
        end

        def meta_description
          record.meta_description
        end

        def metric?
          record.metric?
        end

        def address
          Address.new(record.address)
        end

        def language
          Language.new(record.language)
        end

        def possible_languages
          record.possible_languages
        end

        def currency
          Currency.new(record.currency)
        end

        def account
          Account.new(record.account)
        end

        def current?
          true
        end

        def current_locale
          Filter::Translate.locale
        end

      end
    end
  end
end