module Shoperb
  module Mounter
    module Model
      class Menu < Base

        fields :id, :shop_id, :name, :handle, :editable, :translations

        def self.primary_key
          :handle
        end

        has_many :links
      end
    end
  end
end

