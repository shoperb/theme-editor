module Shoperb
  module Mounter
    module Model
      class Address < Base

        fields :id, :owner_id, :owner_type, :country_id, :state_id, :first_name, :last_name, :phone, :company, :county, :city, :zip, :address1, :address2, :checksum
        fields :email

        # todo: TODOREF2
        # nothing to use as primary_key besides id right now
        # def self.primary_key
        #   :name
        # end
        # todo: TODOREF2 end

        belongs_to :country
        belongs_to :state

        def full_name
          [first_name.presence, last_name.presence].reject(&:blank?).join(" ")
        end

        def full_address
          [address1.presence, address2.presence].reject(&:blank?).join(", ")
        end

        def company_with_phone
          [company, phone].reject(&:blank?).join(", ")
        end

        def city_state_with_zip
          [city.presence, state_name.presence, zip.presence].reject(&:blank?).join(", ")
        end

        def country_name
          country.localized_name
        end

      end
    end
  end
end

