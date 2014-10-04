module Shoperb
  module Mounter
    module Model
      class Address < Base

        fields :id, :owner_id, :owner_type, :country_id, :state_id, :first_name, :last_name, :phone, :company, :county, :city, :zip, :address1, :address2, :checksum

        # todo: TODOREF2
        # nothing to use as primary_key besides id right now
        # def self.primary_key
        #   :name
        # end
        # todo: TODOREF2 end
      end
    end
  end
end

