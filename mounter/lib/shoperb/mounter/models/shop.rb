require "singleton"
module Shoperb
  module Mounter
    module Models
      class Shop < Base
        include Singleton
        belongs_to :currency
      end
    end
  end
end

