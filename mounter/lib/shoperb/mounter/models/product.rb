module Shoperb
  module Mounter
    module Models
      class Product < Base
        has_many :variants
        has_one :image
      end
    end
  end
end

