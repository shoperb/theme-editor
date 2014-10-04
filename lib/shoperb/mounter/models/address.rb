module Shoperb
  module Mounter
    module Model
      class Address < Base
        fields :id, :owner_id, :owner_type, :country_id, :state_id, :first_name, :last_name, :phone, :company, :county, :city, :zip, :address1, :address2, :checksum
      end
    end
  end
end

