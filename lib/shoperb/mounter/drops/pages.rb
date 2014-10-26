module Shoperb
  module Mounter
    module Drop
      class Pages < Collection

        private

        def handle_method
          :permalink
        end

        def collection
          if @collection.empty?
            @collection = Model::Page.all
          end
          @collection
        end

      end
    end
  end
end