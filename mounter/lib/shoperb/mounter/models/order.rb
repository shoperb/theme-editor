module Shoperb
  module Mounter
    module Models
      class Order < Base
        has_many :order_items, name: :items
      end
    end
  end
end

