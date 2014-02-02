require "singleton"
module Shoperb
  module Mounter
    module Models
      class Shop < Base
        include Singleton
      end
      ::Shop = Shop
    end
  end
end

