module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Link < Base

        fields :id, :entity_id, :parent_id, :entity_type, :style, :name,
          :value, :handle, :position, :translations

        translates :name, :description

        def self.primary_key
          :handle
        end
        belongs_to :menu

        def parent
          @parent ||= Link.all.detect { |parent| parent.attributes[:id] == self.parent_id }
        end

        def children
          @children ||= Link.all.select { |child| child.parent_id == attributes[:id] }
        end

        def entity
          return unless entity_type && entity_id
          klass = Model.const_get(entity_type)
          scope = if klass.respond_to?(:active)
            klass.active
          else
            klass.all
          end
          scope.detect { |object| object.attributes[:id] == entity_id }
        end

        def index_action?
          style.downcase == style.downcase.pluralize
        end

        def path(*args)
          return '' unless style

          responder = args[0][:responder]
          path = "store_#{style.underscore}_path"

          case style
            when "CUSTOM"
              value
            when "HOME"
              responder.store_root_path
            when "SEARCH"
              responder.store_search_path
            else
              index_action? ? responder.send(path) : (responder.send(path, entity) if entity)
          end
        end
      end
    end
  end
end end end
