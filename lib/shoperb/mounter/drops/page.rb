module Shoperb
  module Mounter
    module Drop
      class Page < Delegate

        def url
          "/pages/#{@record.permalink}"
        end

      end
    end
  end
end