module Shoperb
  module Mounter
    module Model
      class Shop < Base

        fields :id, :currency_code, :language_code, :name, :domain, :email, :time_zone, :unit_system, :tax_included, :tax_shipping, :possible_languages

        def self.primary_key
          :domain
        end

        def self.instance
          all.first
        end

        belongs_to :currency
        belongs_to :language

        def currency_with_check
          currency_without_check || raise(Error.new("Shops currency has not been set"))
        end
        alias_method_chain :currency, :check

      end
    end
  end
end