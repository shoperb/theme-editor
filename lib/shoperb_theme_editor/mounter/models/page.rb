module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Page < Base

        fields :id, :state, :name, :content, :permalink, :slug, :translations, :template

        translates :name, :content

        def self.primary_key
          :slug
        end

        def handle
          permalink
        end

      end
    end
  end
end end end
