module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Vendor < Base

        def initialize(record)
          @record = record || Model::Vendor.new({})
        end

        def id
          record.id
        end

        def name
          record.name
        end

      end
    end
  end
end end end
