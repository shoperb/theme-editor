module Shoperb
  module Mounter
    module Model
      class ProductAttribute < Abstract::Base
        belongs_to :product
      end
    end
  end
end

