module Shoperb
  module Mounter
    module Model
      class Link < Abstract::Base
        belongs_to :menu
      end
    end
  end
end

