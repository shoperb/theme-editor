module Shoperb
  module Mounter
    module Models
      class Cart < SingletonBase
        self.finder = :name
        has_many :cart_items, name: :items, attribute: :name
      end
    end
  end
end

