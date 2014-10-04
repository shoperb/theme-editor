module Shoperb
  module Mounter
    module Model
      class Link < Base

        fields :id, :entity_id, :entity_type, :style, :name, :value, :handle, :position, :translations, :menu_handle

        # todo: TODOREF1
        # def self.primary_key
        #   :handle
        # end
        # belongs_to :menu, primary_key: "id", foreign_key: "menu_id"

        fields :menu_id

        def menu
          Menu.all.detect { |menu| menu.id == self.menu_handle }
        end
        # todo: TODOREF1 end
      end
    end
  end
end

