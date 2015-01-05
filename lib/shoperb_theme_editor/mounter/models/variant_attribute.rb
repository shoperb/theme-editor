module Shoperb module Theme module Editor
  module Mounter
    module Model
      class VariantAttribute < Base

        fields :id, :handle, :name, :value, :translations

        translates :value

        def self.primary_key
          :handle
        end

        belongs_to :variant

      end
    end
  end
end end end
