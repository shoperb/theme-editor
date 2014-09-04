module Shoperb
  module Mounter
    module Liquid
      module Drop
        class Shop < Liquid::DelegateDrop

          def possible_languages
            @record.possible_languages
          end

        end
      end
    end
  end
end