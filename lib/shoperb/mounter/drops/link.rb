module Shoperb
  module Mounter
    module Drop
      class Link < Delegate

        def url
          case record.style
            when "PRODUCTS"
              "/products"
            when "Page"
              record.entity.to_liquid.url
            when "Collection"
              "javascript:void(0)"
            else
              record.value
          end
        end
      end
    end
  end
end