module Shoperb
  module Mounter
    module Drop
      class ProductCollection < Delegate

        def url
          "/collections/#{@record.name}"
        end

        def products
          Drop::Products.new(@record.products)
        end

      end
    end
  end
end