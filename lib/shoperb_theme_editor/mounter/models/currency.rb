module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Currency < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :name, :code, :symbol, :rate, :date

        def self.primary_key
          :id
        end

      end
    end
  end
end end end
