module Shoperb
  module Editor
    module Models
      class Currency < Base
        has_many :variants
      end
    end
  end
end

