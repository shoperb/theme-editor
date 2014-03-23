module Shoperb
  module Editor
    module Models
      class OrderItem < Base
        belongs_to :order
      end
    end
  end
end

