module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Link < Base

        def id
          record.id
        end

        def url
          case record.style
            when "PRODUCTS"
              "/products"
            when "Page"
              record.entity.to_liquid.url
            when "Collection"
              "javascript:void(0)"
            else
              # TODO: Correct url from "else"
              record.value
          end
        end

        def menu
          record.menu
        end

        def name
          record.name
        end

        def handle
          record.handle
        end

        def object?
          !record.entity.nil?
        end

        def object
          record.entity
        end

      end
    end
  end
end end end
