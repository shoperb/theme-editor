module Shoperb
  module Mounter
    module Drop
      class Menu < Base

        def id
          record.id
        end

        def name
          record.name
        end

        def handle
          record.handle
        end

        def links
          Collection.new(record.links)
        end

      end
    end
  end
end