module Shoperb
  module Mounter
    module Model
      class VariantAttribute < Base

        fields :attribute_key_id, :value, :translations

        belongs_to :variant

        # todo: TODOREF2
        # nothing to use as primary_key besides id right now
      end
    end
  end
end

