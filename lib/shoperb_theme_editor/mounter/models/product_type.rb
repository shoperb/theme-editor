module Shoperb module Theme module Editor
  module Mounter
    module Model
      class ProductType < Base

        fields :id, :name, :handle, :translations

        translates :name

        has_many :products

      end
    end
  end
end end end
