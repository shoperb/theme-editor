module Shoperb
  module Mounter
    module Model
      class Country < Base

        # todo: TODOREF2

        fields :id, :code

        def self.primary_key
          :code
        end

        def localized_name
          Filter::Translate.t("countries.#{code.downcase}")
        end

      end
    end
  end
end
