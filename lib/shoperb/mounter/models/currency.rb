module Shoperb
  module Mounter
    module Model
      class Currency < Abstract::Base
        self.finder = :code
      end
    end
  end
end

