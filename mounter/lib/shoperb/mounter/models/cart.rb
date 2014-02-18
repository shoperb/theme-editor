require "singleton"
module Shoperb
  module Mounter
    module Models
      class Cart < Base
        include Singleton
        has_many :cart_items, name: :items
      end
    end
  end
end

