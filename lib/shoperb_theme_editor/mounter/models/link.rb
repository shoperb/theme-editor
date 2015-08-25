module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Link < Base

        fields :id, :entity_id, :entity_type, :style, :name, :value, :handle, :position, :translations

        translates :name, :description

        def self.primary_key
          :handle
        end
        belongs_to :menu

        def entity
          Model.const_get(entity_type).all.detect { |object| object.attributes[:id] == entity_id } if entity_type && entity_id
        end

      end
    end
  end
end end end
