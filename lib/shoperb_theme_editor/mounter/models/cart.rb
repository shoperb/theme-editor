module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Cart < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :token

        attr_accessor :customer

        def self.primary_key
          :token
        end

        def items
          CartItem
        end

        def total
          items.to_a.sum(&:total)
        end

        def weight
          items.to_a.sum(&:weight)
        end

        def require_shipping?
          items.to_a.any?(&:require_shipping?)
        end

      end
    end
  end
end end end
