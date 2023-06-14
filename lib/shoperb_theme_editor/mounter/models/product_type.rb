module Shoperb module Theme module Editor
  module Mounter
    module Model
      class ProductType < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :name, :handle, :translations

        translates :name

        def self.primary_key
          :handle
        end

        has_many :products

      end
    end
  end
end end end
