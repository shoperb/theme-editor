module Shoperb
  module Editor
    module Models
      class Product < Base
        has_many :variants
        belongs_to :category
        has_one :image
      end
    end
  end
end

