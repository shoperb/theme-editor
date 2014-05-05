module Shoperb
  module Mounter
    module Models
      class Product < Base
        has_many :variants, attribute: :name
        belongs_to :category, attribute: :name
        has_one :image
      end
    end
  end
end

