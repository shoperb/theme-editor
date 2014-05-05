module Shoperb
  module Mounter
    module Models
      class OrderItem < Base
        belongs_to :order, attribute: :name
      end
    end
  end
end

