module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Menu < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel

        fields :id, :name, :handle, :editable, :translations

        translates :name

        def self.primary_key
          :id
        end

        has_many :links

      end
    end
  end
end end end
