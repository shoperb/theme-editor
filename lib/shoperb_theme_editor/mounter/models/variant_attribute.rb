module Shoperb module Theme module Editor
  module Mounter
    module Model
      class VariantAttribute < Base

        fields :id, :handle, :name, :value, :translations

        translates :value

        def self.primary_key
          "id"
        end

        belongs_to :variant

      end
    end
  end
end end end
