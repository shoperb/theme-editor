module Shoperb
  module Mounter
    module Model
      class Currency < Abstract::Base
        has_many :variants, attribute: :name
      end
    end
  end
end

