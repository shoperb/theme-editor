module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Account < Base

        def shops
          Collection.new(Model::Shop.all)
        end

      end
    end
  end
end end end
