module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Menu < Base

        fields :id, :name, :handle, :editable, :translations

        translates :name

        has_many :links

      end
    end
  end
end end end
