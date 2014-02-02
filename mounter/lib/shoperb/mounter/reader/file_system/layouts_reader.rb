module Shoperb
  module Mounter
    module Reader
      module FileSystem

        class LayoutsReader < LiquidBase

          def finder
            '*'
          end

          def model
            Shoperb::Mounter::Models::Layout
          end

          def dir
            'layouts'
          end

        end
      end
    end
  end
end