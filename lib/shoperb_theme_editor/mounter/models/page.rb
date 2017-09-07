module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Page < Base

        fields :id, :state, :name, :content, :permalink, :handle, :translations, :template

        translates :name, :content

        def self.primary_key
          :handle
        end
      end
    end
  end
end end end
