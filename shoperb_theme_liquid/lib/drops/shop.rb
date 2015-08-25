module Shoperb module Theme module Liquid module Drop
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
      record.address.try(:to_liquid, @context)
    end

    def language
      record.language.try(:to_liquid, @context)
    end

    def possible_languages
      record.possible_languages
    end

    def currency
      record.currency.try(:to_liquid, @context)
    end

    def account
      record.account.try(:to_liquid, @context)
    end

    def current?
      true
    end

    def current_locale
      @context.registers[:locale]
    end

  end
end end end end
