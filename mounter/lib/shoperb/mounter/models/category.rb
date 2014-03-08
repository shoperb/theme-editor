module Shoperb
  module Mounter
    module Models
      class Category < Base
        has_many :products

        def ancestors
          IgnoringArray.new
        end

        def children
          IgnoringArray.new
        end

        def products_for_self_and_children
          # TODO: Children products
          self.products
        end

      end
    end
  end
end

