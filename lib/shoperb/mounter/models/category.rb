module Shoperb
  module Mounter
    module Model
      class Category < Abstract::Base
        has_many :products
        has_many :categories, name: :children
        belongs_to :category, name: :parents

        def products_with_children
          products
        end
      end
    end
  end
end

