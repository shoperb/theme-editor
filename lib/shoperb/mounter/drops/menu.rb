module Shoperb
  module Mounter
    module Drop
      class Menu < Delegate

        def links
          __to_drop__ Drop::Collection, :links
        end

      end
    end
  end
end