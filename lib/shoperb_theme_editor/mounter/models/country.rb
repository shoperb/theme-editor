module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Country < Base

        fields :id, :code, :name, :iso3, :numeric, :eu, :na,
          :region_name_key, :abstract, :localized_name

      end
    end
  end
end end end
