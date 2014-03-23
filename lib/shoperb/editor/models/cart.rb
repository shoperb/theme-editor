module Shoperb
  module Editor
    module Models
      class Cart < SingletonBase
        has_many :cart_items, name: :items
      end
    end
  end
end

