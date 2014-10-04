module Shoperb
  module Mounter
    module Model
      class Customer < Base
        has_many :orders
        has_many :addresses
      end
    end
  end
end

