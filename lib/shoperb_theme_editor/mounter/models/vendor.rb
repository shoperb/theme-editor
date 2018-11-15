module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Vendor < Base

        fields :id, :handle, :name, :description, :code, :fax, :phone,
          :email, :website, :contact_name, :contact_phone, :contact_email,
          :translations

        translates :name, :description, :display_name

        def self.primary_key
          :handle
        end

        has_many :products

        def self.not_empty
          all.select { |c| c.products.size > 0 }
        end

        def images
          Image.all.select { |image| image.entity == self }
        end

        def image
          images.first
        end

        def address
          Address.all.detect { |address| address.owner == self }
        end
      end
    end
  end
end end end
