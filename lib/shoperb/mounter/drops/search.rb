module Shoperb
  module Mounter
    module Drop
      class Search < Delegate

        def initialize *args
          @record = Shoperb::Mounter::Model::Search.instance
        end

      end
    end
  end
end