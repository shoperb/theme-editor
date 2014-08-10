module Shoperb
  module Mounter
    module Model
      class Customer < Abstract::SingletonBase
        has_many :orders
        has_many :addresses
      end
    end
  end
end

