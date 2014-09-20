module Shoperb
  module Mounter
    module Drop
      class Account < Delegate

        def shops
          __to_drop__ Drop::Collection, :shops
        end

      end
    end
  end
end