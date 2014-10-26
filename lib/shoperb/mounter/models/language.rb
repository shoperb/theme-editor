module Shoperb
  module Mounter
    module Model
      class Language < Base

        fields :id, :code, :name, :native, :active

        def self.primary_key
          :code
        end

      end
    end
  end
end

