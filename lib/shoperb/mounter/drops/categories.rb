module Shoperb
  module Mounter
    module Drop
      class Categories < Collection
        def roots
          Categories.new(Model::Category.roots)
        end
      end
    end
  end
end

