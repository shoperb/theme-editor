module Shoperb
  module Mounter
    module Models
      class Product < Base
        has_many :variants
      end
    end
  end
end

