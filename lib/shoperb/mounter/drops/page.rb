module Shoperb
  module Mounter
    module Drop
      class Page < Base

        def id
          record.id
        end

        def name
          record.name
        end

        def handle
          record.handle
        end

        def content
          record.content
        end

        def url
          default_url handle
        end

      end
    end
  end
end