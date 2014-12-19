module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Menus < Collection
        def links
          Collection.new(Model::Link.all)
        end

        private

        def collection
          if @collection.empty?
            @collection = Model::Menu.all
          end
          @collection
        end
      end
    end
  end
end end end
