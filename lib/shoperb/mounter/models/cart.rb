module Shoperb
  module Mounter
    module Model
      class Cart < Base

        def self.primary_key
          :token
        end

        def items
          CartItem.all
        end

        def total
          items.sum(&:total)
        end

      end
    end
  end
end

