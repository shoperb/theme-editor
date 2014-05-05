module Shoperb
  module Mounter
    module Models
      class Variant < Base
        belongs_to :product, attribute: :name
        belongs_to :currency, attribute: :name
      end
    end
  end
end

