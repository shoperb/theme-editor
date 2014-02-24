module Shoperb
  module Mounter
    module Models
      class Variant < Base
        belongs_to :product
        belongs_to :currency
      end
    end
  end
end

