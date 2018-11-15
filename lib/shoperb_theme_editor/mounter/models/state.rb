module Shoperb module Theme module Editor
  module Mounter
    module Model
      class State < Base
        fields :id, :country_id, :name, :code

        belongs_to :country
      end
    end
  end
end end end
