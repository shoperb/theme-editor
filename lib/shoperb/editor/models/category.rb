module Shoperb
  module Editor
    module Models
      class Category < Base
        has_many :products
      end
    end
  end
end

