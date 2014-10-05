module Shoperb
  module Mounter
    module Model
      class Collection < Base

        fields :name, :permalink, :slug, :translations

        def self.primary_key
          :slug
        end

      end
    end
  end
end