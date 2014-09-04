module Shoperb
  module Mounter
    module Model
      class Language < Abstract::Base
        def self.finder; "code" end
      end
    end
  end
end

