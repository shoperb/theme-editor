module Shoperb
  module Mounter
    module Model
      class Collection < Abstract::Base
        has_and_belongs_to_many :products
      end
    end
  end
end