module Shoperb
  module Mounter
    module Model
      class Page < Base

        fields :state, :name, :content, :permalink, :slug, :translations, :template

        def self.primary_key
          :slug
        end

      end
    end
  end
end

