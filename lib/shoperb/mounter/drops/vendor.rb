module Shoperb
  module Mounter
    module Drop
      class Vendor < Delegate

        def initialize(record)
          @record = record || Model::Vendor.new({})
        end

      end
    end
  end
end