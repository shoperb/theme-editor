module Shoperb
  module Mounter
    module Reader
      module FileSystem

        class FragmentsReader < LiquidBase

          def finder
            '_*'
          end

          def model
            Shoperb::Mounter::Models::Fragment
          end

          def dir
            'templates'
          end

        end
      end
    end
  end
end