module Shoperb
  module Mounter
    module Model
      class Product < Abstract::Base
        has_many :variants, attribute: :name
        belongs_to :category, attribute: :name
        has_one :image
      end
    end
  end
end

