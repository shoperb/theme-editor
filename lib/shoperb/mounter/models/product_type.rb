module Shoperb
  module Mounter
    module Model
      class ProductType < Base

        fields :name, :handle, :translations

        def self.primary_key
          :handle
        end

        has_many :products

      end
    end
  end
end

