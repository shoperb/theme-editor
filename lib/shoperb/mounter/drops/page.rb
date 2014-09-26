module Shoperb
  module Mounter
    module Drop
      class Page < Delegate

        def url
          "/#{@record.template}"
        end

      end
    end
  end
end