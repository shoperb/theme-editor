module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Address < Base

        fields :id, :owner_id, :owner_type, :country_id, :state_id, :name,
          :first_name, :last_name, :phone, :company, :county, :city, :zip,
          :type,
          :address1, :address2, :checksum, :account_type, :business, :email

        belongs_to :country
        belongs_to :state

        def country_code= val
          self.country = Country.all.detect{|o| o.code == val}
        end

        def state_name
          state.try(:name)
        end

        def order_name
          order.try(:name)
        end

        def full_name
          [first_name.presence, last_name.presence].reject(&:blank?).join(" ")
        end

        def full_address
          [address1.presence, address2.presence].reject(&:blank?).join(", ")
        end

        def company_with_phone
          [company, phone].reject(&:blank?).join(", ")
        end

        def state_with_country
          [state_name.presence, country_name.presence].reject(&:blank?).join(", ")
        end

        def city_state_with_zip
          [city.presence, state_name.presence, zip.presence].reject(&:blank?).join(", ")
        end

        def zip_with_city
          [zip.presence, city.presence].reject(&:blank?).join(", ")
        end

        def country_name
          country&.localized_name
        end

        def owner
          (Model.const_get(owner_type, false) rescue nil).try { |klass|
            klass.all.detect { |obj| obj.attributes[:id] == owner_id }
          }
        end

      end
    end
  end
end end end
