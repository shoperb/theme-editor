module Shoperb
  module Mounter
    module Drop
      class Category < Delegate

        def initialize(record)
          @record = record || Model::Category.new
        end

        def children
          __to_drop__ Drop::Categories, :children
        end

        def parent
          __to_drop__ Drop::Category, :parent
        end

        def parents
          __to_drop__ Drop::Categories, :parents
        end

        def products_with_children
          __to_drop__ Drop::Products, :products_with_children
        end

        def root
          __to_drop__ Drop::Category, :root
        end

      end
    end
  end
end
