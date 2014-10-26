module Shoperb
  module Mounter
    module Drop
      class Account < Base

        def shops
          Collection.new(Model::Shop.all)
        end

      end
    end
  end
end