module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Language < Base

        def name
          record.name
        end

        def code
          record.code
        end

        def active?
          record.active?
        end

      end
    end
  end
end end end
