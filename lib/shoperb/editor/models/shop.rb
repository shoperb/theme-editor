module Shoperb
  module Editor
    module Models
      class Shop < SingletonBase
        belongs_to :currency
      end
    end
  end
end