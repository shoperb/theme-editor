module Shoperb
  module Mounter
    module Model
      class Shop < Abstract::SingletonBase
        belongs_to :currency
        belongs_to :language
      end
    end
  end
end