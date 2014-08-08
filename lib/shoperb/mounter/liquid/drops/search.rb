module Shoperb
  module Mounter
    module Liquid
      module Drop
        class Search < Liquid::DelegateDrop

          def initialize *args
            @record = Shoperb::Mounter::Model::Search.instance
          end

        end
      end
    end
  end
end