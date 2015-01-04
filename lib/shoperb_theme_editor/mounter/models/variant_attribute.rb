module Shoperb module Theme module Editor
  module Mounter
    module Model
      class VariantAttribute < Base

        fields :id, :attribute_key_id, :value, :translations

        translates :value

        belongs_to :variant

        # todo: TODOREF2
        # nothing to use as primary_key besides id right now
      end
    end
  end
end end end
