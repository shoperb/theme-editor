module Shoperb
  module Mounter
    module Model
      class Link < Base

        fields :entity_id, :entity_type, :style, :name, :value, :handle, :position, :translations

        # todo: TODOREF1
        # def self.primary_key
        #   :handle
        # end
        # belongs_to :menu

        fields :menu_id, :menu_handle

        def menu
          Menu.all.detect { |menu| menu.id == self.menu_handle }
        end
        # todo: TODOREF1 end
      end
    end
  end
end

