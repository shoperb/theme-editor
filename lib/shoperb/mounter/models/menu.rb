module Shoperb
  module Mounter
    module Model
      class Menu < Abstract::Base
        has_many :links
      end
    end
  end
end

