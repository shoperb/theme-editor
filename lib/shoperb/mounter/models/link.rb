module Shoperb
  module Mounter
    module Model
      class Link < Base
        fields :id, :menu_id, :entity_id, :entity_type, :style, :name, :value, :handle, :position, :translations

        def self.primary_key
          :handle
        end

        belongs_to :menu
      end
    end
  end
end

