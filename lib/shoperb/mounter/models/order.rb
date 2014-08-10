module Shoperb
  module Mounter
    module Model
      class Order < Abstract::Base
        has_many :order_items, name: :items
      end
    end
  end
end

