module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Country < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :code, :name, :iso3, :numeric, :eu, :na,
          :region_name_key, :abstract
        has_many :states

        def localized_name
          name
        end
      end
    end
  end
end end end
