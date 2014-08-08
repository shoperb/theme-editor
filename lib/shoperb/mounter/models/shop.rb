module Shoperb
  module Mounter
    module Model
      class Shop < Abstract::SingletonBase
        belongs_to :currency, attribute: :name
      end
    end
  end
end