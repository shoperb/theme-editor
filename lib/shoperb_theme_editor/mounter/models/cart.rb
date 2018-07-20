module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Cart < Base

        fields :token

        attr_accessor :customer

        def self.primary_key
          :token
        end

        def items
          CartItem.all
        end

        def total
          items.sum(&:total)
        end

        def weight
          items.sum(&:weight)
        end

        def require_shipping?
          items.any?(&:require_shipping?)
        end

      end
    end
  end
end end end
