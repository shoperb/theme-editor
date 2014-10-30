module Shoperb
  module Mounter
    module Drop
      class ProductType < Base

        def initialize(record)
          @record = record || Model::ProductType.new({})
        end

        def id
          record.id
        end

        def name
          record.name
        end

        def handle
          record.handle
        end

      end
    end
  end
end