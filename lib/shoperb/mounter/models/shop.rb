module Shoperb
  module Mounter
    module Model
      class Shop < Base

        fields :name, :domain, :email, :time_zone, :unit_system, :tax_included, :tax_shipping, :possible_languages

        def self.primary_key
          :domain
        end

        def self.instance
          all.first
        end

        belongs_to :currency
        belongs_to :language

      end
    end
  end
end