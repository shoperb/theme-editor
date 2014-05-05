module Shoperb
  module Mounter
    module Models
      class Shop < SingletonBase
        belongs_to :currency, attribute: :name
      end
    end
  end
end