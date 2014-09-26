module Shoperb
  module Mounter
    module Drop
      class CartItem < Delegate

        def vendor
          __to_drop__ Drop::Vendor, :vendor
        end

        def type
          __to_drop__ Drop::ProductType, :product_type
        end

        def product
          __to_drop__ Drop::Product, :product
        end

        def variant
          __to_drop__ Drop::Variant, :variant
        end

      end
    end
  end
end