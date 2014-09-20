module Shoperb
  module Mounter
    module Drop
      class Cart < Delegate

        def items
          __to_drop__ Drop::Collection, :items
        end

      end
    end
  end
end