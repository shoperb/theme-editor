module Shoperb
  module Mounter
    module Models
      class Currency < Base
        has_many :variants, attribute: :name
      end
    end
  end
end

