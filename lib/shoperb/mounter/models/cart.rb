module Shoperb
  module Mounter
    module Model
      class Cart < Base
        has_many :cart_items, name: :items
      end
    end
  end
end

