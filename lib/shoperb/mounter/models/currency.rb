module Shoperb
  module Mounter
    module Models
      class Currency < Base
        has_many :variants
      end
    end
  end
end

