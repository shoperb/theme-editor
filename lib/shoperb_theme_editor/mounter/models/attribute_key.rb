module Shoperb module Theme module Editor
  module Mounter
    module Model
      class AttributeKey < Sequel::Model
        extend Base::SequelClass
        include Base::Sequel
        fields :id, :name, :handle, :creator_type

        translates :name

        def self.primary_key
          :id
        end
      end
    end
  end
end end end
