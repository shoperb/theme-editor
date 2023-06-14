module Shoperb module Theme module Editor
  module Mounter
    module Model
      class State < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        fields :id, :country_id, :name, :code

        def self.primary_key
          :code
        end

        belongs_to :country
      end
    end
  end
end end end
