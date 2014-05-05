module Shoperb
  module Mounter
    module Models
      class Language < Base
        def self.codes_regexp
          /#{all.map(&:code).join("|")}/
        rescue # need only on project setup from scratch
          ""
        end
      end
    end
  end
end

