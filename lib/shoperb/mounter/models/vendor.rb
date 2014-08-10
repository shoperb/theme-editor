module Shoperb
  module Mounter
    module Model
      class Vendor < Abstract::Base
        has_many :products
        belongs_to :address
      end
    end
  end
end

