module Shoperb
  module Mounter
    module Model
      class Cart < Abstract::SingletonBase
        self.finder = :name
        has_many :cart_items, name: :items, attribute: :name
      end
    end
  end
end

