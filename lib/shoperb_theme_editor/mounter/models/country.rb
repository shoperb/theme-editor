module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Country < Base

        # todo: TODOREF2

        fields :id, :code, :localized_name

        def self.primary_key
          :code
        end

      end
    end
  end
end end end
