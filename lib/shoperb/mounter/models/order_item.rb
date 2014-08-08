module Shoperb
  module Mounter
    module Model
      class OrderItem < Abstract::Base
        belongs_to :order, attribute: :name
      end
    end
  end
end

