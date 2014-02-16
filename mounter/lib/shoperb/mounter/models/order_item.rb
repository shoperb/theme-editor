module Shoperb
  module Mounter
    module Models
      class OrderItem < Base
        belongs_to :order
      end
    end
  end
end

