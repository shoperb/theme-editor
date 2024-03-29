module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Vendor < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :handle, :permalink, :name, :description, :code, :fax, :phone,
          :email, :website, :contact_name, :contact_phone, :contact_email,
          :translations

        translates :name, :description, :display_name

        def self.primary_key
          :permalink
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
