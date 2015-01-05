module Shoperb module Theme module Editor
  module Mounter
    module Drop
      class Link < Base

        def id
          record.id
        end

        def url
          case record.style
            when "CUSTOM"
              record.value
            when "HOME"
              "/"
            when "SEARCH"
              "/search"
            when "PRODUCTS"
              "/products"
            when object?
              object.to_liquid.url
          end
        end

        def index_action?
          s = record.style.downcase
          s == s.pluralize
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
