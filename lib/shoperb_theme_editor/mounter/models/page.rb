module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Page < Base

        fields :id, :state, :name, :content, :permalink, :handle, :translations, :template

        translates :name, :content

        def self.primary_key
          :handle
        end

        def self.active
          all.select(&:active?)
        end

        def active?
          state == "active"
        end
      end
    end
  end
end end end
