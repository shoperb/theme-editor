module Shoperb
  module Mounter
    module Model
      class VariantAttribute < Abstract::Base
        belongs_to :variant
      end
    end
  end
end

