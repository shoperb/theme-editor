module Shoperb module Theme module Liquid module Drop
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
        when "Collections"
          "/collections"
        when "BlogPosts"
          if object?
            object.try(:to_liquid, @context).try(:url)
          else
            "/blog"
          end
        else
          object.try(:to_liquid, @context).try(:url)
      end
    end

    def index_action?
      s = record.style.downcase
      s == s.pluralize
    end

    def style
      record.style.try(:underscore)
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

    def parent
      record.parent.try(:to_liquid, @context)
    end

    def children
      Collection.new(record.children).tap do |drop|
        drop.context = @context
      end
    end

    def children?
      record.children.any?
    end

    def object?
      !record.entity.nil?
    end

    def object
      record.entity
    end

  end
end end end end
