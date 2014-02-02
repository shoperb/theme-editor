module Shoperb
  module Mounter
    module Reader
      module FileSystem

        class TemplatesReader < LiquidBase

          def finder
            '[^_]*'
          end

          def model
            Shoperb::Mounter::Models::Template
          end

          def dir
            'templates'
          end

        end
      end
    end
  end
end