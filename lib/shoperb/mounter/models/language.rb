module Shoperb
  module Mounter
    module Model
      class Language < Abstract::Base
        def self.codes_regexp
          /#{all.map(&:code).join("|")}/
        rescue # need only on project setup from scratch
          ""
        end
      end
    end
  end
end

