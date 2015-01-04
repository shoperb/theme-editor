module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Currency < Base

        def name
          record.name
        end

        def code
          record.code
        end

        def symbol
          record.symbol
        end

      end
    end
  end
end end end
