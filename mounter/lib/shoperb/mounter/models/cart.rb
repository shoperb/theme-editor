require "singleton"
module Shoperb
  module Mounter
    module Models
      class Cart < Base
        include Singleton
      end
      ::Cart = Cart
    end
  end
end

