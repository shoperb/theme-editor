module Shoperb module Theme module Editor
  module Mounter
    module Model
      class Currency < Base

        fields :id, :name, :code, :symbol, :rate, :date

        def self.primary_key
          :code
        end

      end
    end
  end
end end end
