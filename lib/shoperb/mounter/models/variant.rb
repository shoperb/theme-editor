module Shoperb
  module Mounter
    module Model
      class Variant < Abstract::Base
        belongs_to :product, attribute: :name
        belongs_to :currency, attribute: :name
      end
    end
  end
end

