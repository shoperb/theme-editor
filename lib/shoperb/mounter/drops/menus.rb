module Shoperb
  module Mounter
    module Drop
      class Menus < Collection
        def links
          Collection.new(Model::Link.all)
        end
      end
    end
  end
end