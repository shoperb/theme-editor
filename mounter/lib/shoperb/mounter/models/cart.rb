require "singleton"
module Shoperb
  module Mounter
    module Models
      class Cart < Base
        include Singleton
        has_many :order_items, name: :items
      end
    end
  end
end

