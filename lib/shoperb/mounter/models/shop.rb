module Shoperb
  module Mounter
    module Models
      class Shop < SingletonBase
        belongs_to :currency
      end
    end
  end
end