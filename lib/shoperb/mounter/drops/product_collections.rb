module Shoperb
  module Mounter
    module Drop
      class ProductCollections < Collection

        private

        def collection
          if @collection.empty?
            @collection = Model::Collection.all
          end
          @collection
        end

        def handle_method
          :slug
        end

      end
    end
  end
end