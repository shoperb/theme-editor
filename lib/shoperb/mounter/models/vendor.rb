module Shoperb
  module Mounter
    module Model
      class Vendor < Base

        fields :name, :code, :fax, :phone, :email, :website, :contact_name, :contact_phone, :contact_email, :note, :translations

        def self.primary_key
          :code
        end

      end
    end
  end
end

