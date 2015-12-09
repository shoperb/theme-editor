module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Cart < Base

        fields :token

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
end end end
