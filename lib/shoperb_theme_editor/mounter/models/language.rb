module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Language < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :code, :name, :native, :active

        def self.primary_key
          :code
        end

      end
    end
  end
end end end
