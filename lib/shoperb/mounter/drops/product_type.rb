module Shoperb
  module Mounter
    module Drop
      class ProductType < Delegate

        def initialize(record)
          @record = record || Model::ProductType.new({})
        end

      end
    end
  end
end