module Shoperb
  module Mounter
    module Model
      class Cart < Abstract::SingletonBase
        has_many :cart_items, name: :items
      end
    end
  end
end

