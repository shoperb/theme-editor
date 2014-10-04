module Shoperb
  module Mounter
    module Model
      class Image < Base

        fields :id, :entity_id, :entity_type, :name, :sizes

        # todo: TODOREF2
        # nothing to use as primary_key besides id right now
        # def self.primary_key
        #   :name
        # end
        # todo: TODOREF2 end
      end
    end
  end
end

