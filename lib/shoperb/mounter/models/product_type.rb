module Shoperb
  module Mounter
    module Model
      class ProductType < Abstract::Base
        has_many :products
      end
    end
  end
end

