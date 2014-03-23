module Shoperb
  module Editor
    module Models
      class Order < Base
        has_many :order_items, name: :items
      end
    end
  end
end

