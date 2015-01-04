module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Vendor < Base

        fields :id, :name, :code, :fax, :phone, :email, :website, :contact_name, :contact_phone, :contact_email, :note, :translations

        translates :name

        def self.primary_key
          :code
        end

      end
    end
  end
end end end
