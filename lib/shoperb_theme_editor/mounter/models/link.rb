module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Link < Base

        fields :id, :entity_id, :parent_id, :entity_type, :style, :name, :value, :handle, :position, :translations

        translates :name, :description

        def self.primary_key
          :handle
        end
        belongs_to :menu

        def parent
          Link.all.detect { |parent| parent.attributes[:id] == self.parent_id }
        end

        def children
          Link.all.select { |child| child.parent_id == attributes[:id] }
        end

        def entity
          Model.const_get(entity_type).all.detect { |object| object.attributes[:id] == entity_id } if entity_type && entity_id
        end

      end
    end
  end
end end end
